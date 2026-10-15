const express = require('express');
const {
  createRazorpayOrder,
  verifyPayment,
  getPaymentDetails,
  processRefund,
} = require('../controllers/paymentController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.post('/create-order', protect, createRazorpayOrder);
router.post('/verify', protect, verifyPayment);
router.get('/:orderId', protect, getPaymentDetails);
router.post('/:orderId/refund', protect, admin, processRefund);

module.exports = router;
