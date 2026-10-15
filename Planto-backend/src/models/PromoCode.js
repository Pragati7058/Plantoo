const mongoose = require('mongoose');

const promoCodeSchema = new mongoose.Schema({
  code: {
    type: String,
    required: true,
    unique: true,
    uppercase: true,
    trim: true,
  },
  discountType: {
    type: String,
    enum: ['percentage', 'fixed'],
    required: true,
  },
  discountValue: {
    type: Number,
    required: true,
  },
  minOrderAmount: {
    type: Number,
    default: 0,
  },
  maxDiscountAmount: {
    type: Number,
    default: null,
  },
  usageLimit: {
    type: Number,
    default: null,
  },
  usedCount: {
    type: Number,
    default: 0,
  },
  validFrom: {
    type: Date,
    default: Date.now,
  },
  validUntil: {
    type: Date,
    required: true,
  },
  isActive: {
    type: Boolean,
    default: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

promoCodeSchema.methods.isValid = function() {
  const now = new Date();
  return (
    this.isActive &&
    this.usedCount < (this.usageLimit || Infinity) &&
    now >= this.validFrom &&
    now <= this.validUntil
  );
};

promoCodeSchema.methods.calculateDiscount = function(orderAmount) {
  if (!this.isValid()) return 0;
  
  if (orderAmount < this.minOrderAmount) return 0;
  
  let discount = 0;
  
  if (this.discountType === 'percentage') {
    discount = (orderAmount * this.discountValue) / 100;
  } else {
    discount = this.discountValue;
  }
  
  if (this.maxDiscountAmount && discount > this.maxDiscountAmount) {
    discount = this.maxDiscountAmount;
  }
  
  return discount;
};

promoCodeSchema.methods.incrementUsage = async function() {
  this.usedCount += 1;
  await this.save();
};

module.exports = mongoose.model('PromoCode', promoCodeSchema);
