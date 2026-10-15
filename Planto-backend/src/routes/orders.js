const express = require('express');
const {
  createOrder,
  getUserOrders,
  getOrderById,
  updateOrderStatus,
  getAllOrders,
} = require('../controllers/orderController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .post(protect, createOrder)
  .get(protect, getUserOrders);

router.get('/all', protect, admin, getAllOrders);

router.route('/:id')
  .get(protect, getOrderById);

router.put('/:id/status', protect, admin, updateOrderStatus);

module.exports = router;