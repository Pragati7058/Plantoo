const express = require('express');
const {
  getNotifications,
  markAsRead,
  markAllAsRead,
  deleteNotification,
  clearNotifications,
  createNotification,
} = require('../controllers/notificationController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, getNotifications)
  .delete(protect, clearNotifications)
  .post(protect, admin, createNotification);

router.put('/read-all', protect, markAllAsRead);

router.route('/:id')
  .put(protect, markAsRead)
  .delete(protect, deleteNotification);

module.exports = router;