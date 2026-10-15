const Wishlist = require('../models/Wishlist');
const Plant = require('../models/Plant');

// @desc    Get user wishlist
// @route   GET /api/wishlist
// @access  Private
const getWishlist = async (req, res) => {
  try {
    const wishlistItems = await Wishlist.find({ user: req.user._id })
      .populate('plant', 'name price imageUrl rating isPetFriendly')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      count: wishlistItems.length,
      data: wishlistItems,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Add plant to wishlist
// @route   POST /api/wishlist
// @access  Private
const addToWishlist = async (req, res) => {
  try {
    const { plantId } = req.body;

    // Check if plant exists
    const plant = await Plant.findById(plantId);
    if (!plant) {
      return res.status(404).json({ message: 'Plant not found' });
    }

    // Check if plant is already in wishlist
    const existingItem = await Wishlist.findOne({
      user: req.user._id,
      plant: plantId,
    });

    if (existingItem) {
      return res.status(400).json({ message: 'Plant already in wishlist' });
    }

    // Create wishlist item
    const wishlistItem = await Wishlist.create({
      user: req.user._id,
      plant: plantId,
      plantName: plant.name,
      imageUrl: plant.imageUrl,
      price: plant.price,
    });

    res.status(201).json({
      success: true,
      data: wishlistItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Remove plant from wishlist
// @route   DELETE /api/wishlist/:plantId
// @access  Private
const removeFromWishlist = async (req, res) => {
  try {
    const wishlistItem = await Wishlist.findOneAndDelete({
      plant: req.params.plantId,
      user: req.user._id,
    });

    if (!wishlistItem) {
      return res.status(404).json({ message: 'Plant not found in wishlist' });
    }

    res.json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Check if plant is in wishlist
// @route   GET /api/wishlist/check/:plantId
// @access  Private
const checkInWishlist = async (req, res) => {
  try {
    const wishlistItem = await Wishlist.findOne({
      plant: req.params.plantId,
      user: req.user._id,
    });

    res.json({
      success: true,
      inWishlist: !!wishlistItem,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Clear wishlist
// @route   DELETE /api/wishlist
// @access  Private
const clearWishlist = async (req, res) => {
  try {
    await Wishlist.deleteMany({ user: req.user._id });

    res.json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getWishlist,
  addToWishlist,
  removeFromWishlist,
  checkInWishlist,
  clearWishlist,
};