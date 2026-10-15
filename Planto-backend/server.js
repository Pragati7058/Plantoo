const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const { connectDB } = require('./src/config/index');
const errorHandler = require('./src/middleware/errorHandler');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Connect to database
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Basic route
app.get('/', (req, res) => {
  res.json({ message: 'Planto Backend API is running!' });
});

// Routes
app.use('/api/auth', require('./src/routes/auth'));
app.use('/api/plants', require('./src/routes/plants'));
app.use('/api/categories', require('./src/routes/categories'));
app.use('/api/cart', require('./src/routes/cart'));
app.use('/api/orders', require('./src/routes/orders'));
app.use('/api/wishlist', require('./src/routes/wishlist'));
app.use('/api/notifications', require('./src/routes/notifications'));
app.use('/api/payment', require('./src/routes/payment'));
app.use('/api/addresses', require('./src/routes/addresses'));
app.use('/api/promo', require('./src/routes/promo'));

// Error handling middleware
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});