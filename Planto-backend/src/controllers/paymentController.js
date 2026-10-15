const Razorpay = require('razorpay');
const Order = require('../models/Order');
const CartItem = require('../models/CartItem');
const Plant = require('../models/Plant');

// Initialize Razorpay instance
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID || 'rzp_test_demo_key',
  key_secret: process.env.RAZORPAY_KEY_SECRET || 'demo_secret',
});

// @desc    Create Razorpay order
// @route   POST /api/payment/create-order
// @access  Private
const createRazorpayOrder = async (req, res) => {
  try {
    const { amount, currency = 'INR' } = req.body;

    // Get user's cart to calculate total
    const cartItems = await CartItem.find({ user: req.user.id })
      .populate('plant', 'name price isInStock');

    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    // Calculate total from cart
    const totalAmount = cartItems.reduce(
      (sum, item) => sum + (item.plant.price * item.quantity),
      0
    );

    // Convert to paise (Razorpay uses smallest currency unit)
    const amountInPaise = Math.round(totalAmount * 100);

    // Create Razorpay order
    const options = {
      amount: amountInPaise,
      currency,
      receipt: `order_${Date.now()}`,
      notes: {
        userId: req.user.id,
      },
    };

    const razorpayOrder = await razorpay.orders.create(options);

    res.status(201).json({
      success: true,
      data: {
        id: razorpayOrder.id,
        amount: razorpayOrder.amount,
        currency: razorpayOrder.currency,
        receipt: razorpayOrder.receipt,
      },
    });
  } catch (error) {
    console.error('Razorpay order creation error:', error);
    res.status(500).json({ message: error.message });
  }
};

// @desc    Verify Razorpay payment
// @route   POST /api/payment/verify
// @access  Private
const verifyPayment = async (req, res) => {
  try {
    const {
      razorpayOrderId,
      razorpayPaymentId,
      razorpaySignature,
      shippingAddress,
    } = req.body;

    // Verify signature
    const crypto = require('crypto');
    const expectedSignature = crypto
      .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET || 'demo_secret')
      .update(`${razorpayOrderId}|${razorpayPaymentId}`)
      .digest('hex');

    if (razorpaySignature !== expectedSignature) {
      return res.status(400).json({ message: 'Invalid payment signature' });
    }

    // Get user's cart
    const cartItems = await CartItem.find({ user: req.user.id })
      .populate('plant', 'name price imageUrl isInStock');

    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    // Create order items
    const orderItems = cartItems.map(item => ({
      plant: item.plant._id,
      plantName: item.plant.name,
      imageUrl: item.plant.imageUrl,
      price: item.plant.price,
      quantity: item.quantity,
    }));

    // Calculate total
    const totalAmount = orderItems.reduce(
      (sum, item) => sum + (item.price * item.quantity),
      0
    );

    // Generate tracking number
    const trackingNumber = `PLT${Date.now().toString().slice(-8)}${Math.floor(Math.random() * 1000)}`;

    // Create order with payment info
    const order = await Order.create({
      user: req.user.id,
      items: orderItems,
      totalAmount,
      shippingAddress: {
        ...shippingAddress,
        phone: shippingAddress.phone || '',
      },
      status: 'processing',
      paymentInfo: {
        paymentId: razorpayPaymentId,
        orderId: razorpayOrderId,
        signature: razorpaySignature,
        amount: totalAmount,
        currency: 'INR',
        status: 'paid',
        paidAt: Date.now(),
      },
      tracking: {
        trackingNumber,
        carrier: 'Planto Express',
        estimatedDelivery: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000), // 5 days from now
        currentLocation: 'Warehouse',
        trackingHistory: [
          {
            status: 'Order Placed',
            location: 'Warehouse',
            description: 'Order has been placed and payment confirmed',
            timestamp: Date.now(),
          },
        ],
      },
    });

    // Clear cart
    await CartItem.deleteMany({ user: req.user.id });

    // Create notification
    const Notification = require('../models/Notification');
    await Notification.create({
      user: req.user.id,
      title: 'Payment Successful',
      message: `Your order #${order._id} has been placed successfully. Tracking: ${trackingNumber}`,
      type: 'order',
    });

    res.status(201).json({
      success: true,
      data: order,
    });
  } catch (error) {
    console.error('Payment verification error:', error);
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get payment details
// @route   GET /api/payment/:orderId
// @access  Private
const getPaymentDetails = async (req, res) => {
  try {
    const order = await Order.findById(req.params.orderId);

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Check if user owns the order
    if (order.user.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Not authorized' });
    }

    res.json({
      success: true,
      data: order.paymentInfo,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Process refund
// @route   POST /api/payment/:orderId/refund
// @access  Private/Admin
const processRefund = async (req, res) => {
  try {
    const order = await Order.findById(req.params.orderId);

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    if (order.paymentInfo.status !== 'paid') {
      return res.status(400).json({ message: 'Payment is not in paid status' });
    }

    // Process refund through Razorpay
    const refund = await razorpay.payments.refund(order.paymentInfo.paymentId, {
      amount: Math.round(order.paymentInfo.amount * 100), // Convert to paise
    });

    // Update order payment status
    order.paymentInfo.status = 'refunded';
    await order.save();

    // Create notification
    const Notification = require('../models/Notification');
    await Notification.create({
      user: order.user,
      title: 'Refund Processed',
      message: `Your refund for order #${order._id} has been processed.`,
      type: 'order',
    });

    res.json({
      success: true,
      data: refund,
    });
  } catch (error) {
    console.error('Refund error:', error);
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  createRazorpayOrder,
  verifyPayment,
  getPaymentDetails,
  processRefund,
};
