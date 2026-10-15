const Plant = require('../models/Plant');

// @desc    Get all plants
// @route   GET /api/plants
// @access  Public
const getPlants = async (req, res) => {
  try {
    const { category, search, minPrice, maxPrice, isPetFriendly } = req.query;

    let query = {};

    // Filter by category
    if (category) {
      query.category = category;
    }

    // Filter by pet friendly
    if (isPetFriendly === 'true') {
      query.isPetFriendly = true;
    }

    // Filter by price range
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = parseFloat(minPrice);
      if (maxPrice) query.price.$lte = parseFloat(maxPrice);
    }

    // Search by name
    if (search) {
      query.name = { $regex: search, $options: 'i' };
    }

    const plants = await Plant.find(query);

    res.json({
      success: true,
      count: plants.length,
      data: plants,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get single plant
// @route   GET /api/plants/:id
// @access  Public
const getPlantById = async (req, res) => {
  try {
    const plant = await Plant.findById(req.params.id);

    if (!plant) {
      return res.status(404).json({ message: 'Plant not found' });
    }

    res.json({
      success: true,
      data: plant,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Create a new plant
// @route   POST /api/plants
// @access  Private/Admin
const createPlant = async (req, res) => {
  try {
    const plant = await Plant.create(req.body);

    res.status(201).json({
      success: true,
      data: plant,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update plant
// @route   PUT /api/plants/:id
// @access  Private/Admin
const updatePlant = async (req, res) => {
  try {
    const plant = await Plant.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!plant) {
      return res.status(404).json({ message: 'Plant not found' });
    }

    res.json({
      success: true,
      data: plant,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete plant
// @route   DELETE /api/plants/:id
// @access  Private/Admin
const deletePlant = async (req, res) => {
  try {
    const plant = await Plant.findByIdAndDelete(req.params.id);

    if (!plant) {
      return res.status(404).json({ message: 'Plant not found' });
    }

    res.json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getPlants,
  getPlantById,
  createPlant,
  updatePlant,
  deletePlant,
};