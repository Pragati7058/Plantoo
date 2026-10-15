const PromoCode = require('../models/PromoCode');

// @desc    Validate and apply promo code
// @route   POST /api/promo/validate
// @access  Private
const validatePromoCode = async (req, res) => {
  try {
    const { code, orderAmount } = req.body;

    if (!code || !orderAmount) {
      return res.status(400).json({ 
        success: false, 
        message: 'Code and order amount are required' 
      });
    }

    const promoCode = await PromoCode.findOne({ code: code.toUpperCase() });

    if (!promoCode) {
      return res.status(404).json({ 
        success: false, 
        message: 'Invalid promo code' 
      });
    }

    if (!promoCode.isValid()) {
      return res.status(400).json({ 
        success: false, 
        message: 'Promo code is expired or inactive' 
      });
    }

    if (orderAmount < promoCode.minOrderAmount) {
      return res.status(400).json({ 
        success: false, 
        message: `Minimum order amount is ₹${promoCode.minOrderAmount}` 
      });
    }

    const discount = promoCode.calculateDiscount(orderAmount);

    res.json({
      success: true,
      data: {
        code: promoCode.code,
        discountType: promoCode.discountType,
        discountValue: promoCode.discountValue,
        discountAmount: discount,
        finalAmount: orderAmount - discount,
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Create promo code (Admin only)
// @route   POST /api/promo
// @access  Private/Admin
const createPromoCode = async (req, res) => {
  try {
    const { code, discountType, discountValue, minOrderAmount, maxDiscountAmount, usageLimit, validUntil } = req.body;

    const promoCode = await PromoCode.create({
      code,
      discountType,
      discountValue,
      minOrderAmount,
      maxDiscountAmount,
      usageLimit,
      validUntil,
    });

    res.status(201).json({
      success: true,
      data: promoCode,
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({ 
        success: false, 
        message: 'Promo code already exists' 
      });
    }
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all promo codes (Admin only)
// @route   GET /api/promo
// @access  Private/Admin
const getPromoCodes = async (req, res) => {
  try {
    const promoCodes = await PromoCode.find({}).sort({ createdAt: -1 });

    res.json({
      success: true,
      data: promoCodes,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete promo code (Admin only)
// @route   DELETE /api/promo/:id
// @access  Private/Admin
const deletePromoCode = async (req, res) => {
  try {
    const promoCode = await PromoCode.findById(req.params.id);

    if (!promoCode) {
      return res.status(404).json({ 
        success: false, 
        message: 'Promo code not found' 
      });
    }

    await promoCode.deleteOne();

    res.json({
      success: true,
      message: 'Promo code deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  validatePromoCode,
  createPromoCode,
  getPromoCodes,
  deletePromoCode,
};
