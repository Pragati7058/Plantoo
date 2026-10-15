const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  plant: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Plant',
    required: true,
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 5,
  },
  comment: {
    type: String,
    required: [true, 'Please provide a comment'],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Add index for user+plant combination to prevent multiple reviews per user per plant
reviewSchema.index({ user: 1, plant: 1 }, { unique: true });

module.exports = mongoose.model('Review', reviewSchema);