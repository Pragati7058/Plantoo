const express = require('express');
const {
  getAddresses,
  addAddress,
  updateAddress,
  deleteAddress,
  setDefaultAddress,
} = require('../controllers/addressController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, getAddresses)
  .post(protect, addAddress);

router.route('/:addressId')
  .put(protect, updateAddress)
  .delete(protect, deleteAddress);

router.put('/:addressId/default', protect, setDefaultAddress);

module.exports = router;
