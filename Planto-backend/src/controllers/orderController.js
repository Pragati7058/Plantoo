const Order = require('../models/Order');
const CartItem = require('../models/CartItem');
const Plant = require('../models/Plant');

// @desc    Create new order
// @route   POST /api/orders
// @access  Private
const createOrder = async (req, res) => {
  try {
    const { shippingAddress } = req.body;

    // Get user's cart
    const cartItems = await CartItem.find({ user: req.user._id })
      .populate('plant', 'name price imageUrl isInStock');

    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    // Check if all plants are in stock
    for (const item of cartItems) {
      if (!item.plant.isInStock) {
        return res.status(400).json({ 
          message: `${item.plant.name} is out of stock` 
        });
      }
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

    // Create order
    const order = await Order.create({
      user: req.user._id,
      items: orderItems,
      totalAmount,
      shippingAddress,
      status: 'pending',
    });

    // Clear cart
    await CartItem.deleteMany({ user: req.user._id });

    // Create notification
    const Notification = require('../models/Notification');
    await Notification.create({
      user: req.user._id,
      title: 'Order Placed',
      message: `Your order #${order._id} has been placed successfully.`,
      type: 'order',
    });

    res.status(201).json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user orders
// @route   GET /api/orders
// @access  Private
const getUserOrders = async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user._id })
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: orders.length,
      data: orders,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get single order
// @route   GET /api/orders/:id
// @access  Private
const getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('user', 'name email');

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Check if user owns the order or is admin
    if (order.user._id.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Not authorized' });
    }

    res.json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update order status (admin only)
// @route   PUT /api/orders/:id/status
// @access  Private/Admin
const updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;

    const validStatuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ message: 'Invalid status' });
    }

    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    // Create notification for user
    const Notification = require('../models/Notification');
    await Notification.create({
      user: order.user,
      title: 'Order Status Updated',
      message: `Your order #${order._id} status has been updated to ${status}.`,
      type: 'order',
    });

    res.json({
      success: true,
      data: order,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all orders (admin only)
// @route   GET /api/orders/all
// @access  Private/Admin
const getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find()
      .populate('user', 'name email')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: orders.length,
      data: orders,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  createOrder,
  getUserOrders,
  getOrderById,
  updateOrderStatus,
  getAllOrders,
};