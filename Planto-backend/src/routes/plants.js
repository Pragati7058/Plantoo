const express = require('express');
const {
  getPlants,
  getPlantById,
  createPlant,
  updatePlant,
  deletePlant,
} = require('../controllers/plantController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(getPlants)
  .post(protect, admin, createPlant);

router.route('/:id')
  .get(getPlantById)
  .put(protect, admin, updatePlant)
  .delete(protect, admin, deletePlant);

module.exports = router;