const mongoose = require('mongoose');

const careInfoSchema = new mongoose.Schema({
  water: {
    type: String,
    required: true,
  },
  light: {
    type: String,
    required: true,
  },
  humidity: {
    type: String,
    required: true,
  },
  temperature: {
    type: String,
    required: true,
  },
});

const plantSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please provide a plant name'],
    trim: true,
  },
  category: {
    type: String,
    required: [true, 'Please provide a category'],
    trim: true,
  },
  price: {
    type: Number,
    required: [true, 'Please provide a price'],
    min: 0,
  },
  imageUrl: {
    type: String,
    required: [true, 'Please provide an image URL'],
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  reviews: {
    type: Number,
    default: 0,
    min: 0,
  },
  description: {
    type: String,
    required: [true, 'Please provide a description'],
  },
  careInfo: {
    type: careInfoSchema,
    required: true,
  },
  isPetFriendly: {
    type: Boolean,
    default: false,
  },
  isInStock: {
    type: Boolean,
    default: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Plant', plantSchema);