const CartItem = require('../models/CartItem');
const Plant = require('../models/Plant');

// @desc    Get user cart
// @route   GET /api/cart
// @access  Private
const getCart = async (req, res) => {
  try {
    console.log('getCart: req.user._id:', req.user._id);
    const cartItems = await CartItem.find({ user: req.user._id })
      .populate('plant', 'name price imageUrl isInStock');

    // Calculate total
    const total = cartItems.reduce((sum, item) => {
      return sum + (item.price * item.quantity);
    }, 0);

    res.json({
      success: true,
      count: cartItems.length,
      total,
      items: cartItems,
    });
  } catch (error) {
    console.error('getCart error:', error.message);
    res.status(500).json({ message: error.message });
  }
};

// @desc    Add item to cart
// @route   POST /api/cart
// @access  Private
const addToCart = async (req, res) => {
  try {
    const { plantId, quantity = 1 } = req.body;

    // Check if plant exists
    const plant = await Plant.findById(plantId);
    if (!plant) {
      return res.status(404).json({ message: 'Plant not found' });
    }

    if (!plant.isInStock) {
      return res.status(400).json({ message: 'Plant is out of stock' });
    }

    // Check if item already exists in cart
    let cartItem = await CartItem.findOne({
      user: req.user._id,
      plant: plantId,
    });

    if (cartItem) {
      // Update quantity if item exists
      cartItem.quantity += quantity;
      await cartItem.save();
    } else {
      // Create new cart item
      cartItem = await CartItem.create({
        user: req.user._id,
        plant: plantId,
        plantName: plant.name,
        imageUrl: plant.imageUrl,
        price: plant.price,
        quantity,
      });
    }

    res.status(201).json({
      success: true,
      data: cartItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update cart item quantity
// @route   PUT /api/cart/:itemId
// @access  Private
const updateCartItem = async (req, res) => {
  try {
    const { quantity } = req.body;

    if (quantity < 1) {
      return res.status(400).json({ message: 'Quantity must be at least 1' });
    }

    const cartItem = await CartItem.findOneAndUpdate(
      { _id: req.params.itemId, user: req.user._id },
      { quantity },
      { new: true }
    );

    if (!cartItem) {
      return res.status(404).json({ message: 'Cart item not found' });
    }

    res.json({
      success: true,
      data: cartItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Remove item from cart
// @route   DELETE /api/cart/:itemId
// @access  Private
const removeFromCart = async (req, res) => {
  try {
    const cartItem = await CartItem.findOneAndDelete({
      _id: req.params.itemId,
      user: req.user._id,
    });

    if (!cartItem) {
      return res.status(404).json({ message: 'Cart item not found' });
    }

    res.json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Clear cart
// @route   DELETE /api/cart
// @access  Private
const clearCart = async (req, res) => {
  try {
    await CartItem.deleteMany({ user: req.user._id });

    res.json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getCart,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
};