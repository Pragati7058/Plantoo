const User = require('../models/User');

// @desc    Get user addresses
// @route   GET /api/addresses
// @access  Private
const getAddresses = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('addresses');

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({
      success: true,
      count: user.addresses.length,
      data: user.addresses,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Add new address
// @route   POST /api/addresses
// @access  Private
const addAddress = async (req, res) => {
  try {
    const { street, city, state, zipCode, country, phone, isDefault } = req.body;

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // If setting as default, remove default from other addresses
    if (isDefault) {
      user.addresses.forEach(addr => {
        addr.isDefault = false;
      });
    }

    // Add new address
    user.addresses.push({
      street,
      city,
      state,
      zipCode,
      country,
      phone,
      isDefault: isDefault || false,
    });

    await user.save();

    res.status(201).json({
      success: true,
      data: user.addresses,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update address
// @route   PUT /api/addresses/:addressId
// @access  Private
const updateAddress = async (req, res) => {
  try {
    const { street, city, state, zipCode, country, phone, isDefault } = req.body;

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const addressIndex = user.addresses.findIndex(
      addr => addr._id.toString() === req.params.addressId
    );

    if (addressIndex === -1) {
      return res.status(404).json({ message: 'Address not found' });
    }

    // If setting as default, remove default from other addresses
    if (isDefault) {
      user.addresses.forEach(addr => {
        addr.isDefault = false;
      });
    }

    // Update address
    user.addresses[addressIndex] = {
      ...user.addresses[addressIndex],
      street: street || user.addresses[addressIndex].street,
      city: city || user.addresses[addressIndex].city,
      state: state || user.addresses[addressIndex].state,
      zipCode: zipCode || user.addresses[addressIndex].zipCode,
      country: country || user.addresses[addressIndex].country,
      phone: phone || user.addresses[addressIndex].phone,
      isDefault: isDefault !== undefined ? isDefault : user.addresses[addressIndex].isDefault,
    };

    await user.save();

    res.json({
      success: true,
      data: user.addresses,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete address
// @route   DELETE /api/addresses/:addressId
// @access  Private
const deleteAddress = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const addressIndex = user.addresses.findIndex(
      addr => addr._id.toString() === req.params.addressId
    );

    if (addressIndex === -1) {
      return res.status(404).json({ message: 'Address not found' });
    }

    user.addresses.splice(addressIndex, 1);
    await user.save();

    res.json({
      success: true,
      data: user.addresses,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Set default address
// @route   PUT /api/addresses/:addressId/default
// @access  Private
const setDefaultAddress = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const addressIndex = user.addresses.findIndex(
      addr => addr._id.toString() === req.params.addressId
    );

    if (addressIndex === -1) {
      return res.status(404).json({ message: 'Address not found' });
    }

    // Remove default from all addresses
    user.addresses.forEach(addr => {
      addr.isDefault = false;
    });

    // Set selected address as default
    user.addresses[addressIndex].isDefault = true;

    await user.save();

    res.json({
      success: true,
      data: user.addresses,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getAddresses,
  addAddress,
  updateAddress,
  deleteAddress,
  setDefaultAddress,
};
