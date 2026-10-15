const express = require('express');
const router = express.Router();
const {
  validatePromoCode,
  createPromoCode,
  getPromoCodes,
  deletePromoCode,
} = require('../controllers/promoController');
const { protect, admin } = require('../middleware/auth');

router.post('/validate', protect, validatePromoCode);
router.post('/', protect, admin, createPromoCode);
router.get('/', protect, admin, getPromoCodes);
router.delete('/:id', protect, admin, deletePromoCode);

module.exports = router;
