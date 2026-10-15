const express = require('express');
const {
  getWishlist,
  addToWishlist,
  removeFromWishlist,
  checkInWishlist,
  clearWishlist,
} = require('../controllers/wishlistController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, getWishlist)
  .post(protect, addToWishlist)
  .delete(protect, clearWishlist);

router.get('/check/:plantId', protect, checkInWishlist);

router.delete('/:plantId', protect, removeFromWishlist);

module.exports = router;