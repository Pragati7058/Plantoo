const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Get token from header
      token = req.headers.authorization.split(' ')[1];
      console.log('Auth middleware: Token received');

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      console.log('Auth middleware: Decoded user ID:', decoded.id);

      // Get user from token
      req.user = await User.findById(decoded.id).select('-password');
      console.log('Auth middleware: User found:', !!req.user);

      if (!req.user) {
        console.log('Auth middleware: User not found in database for ID:', decoded.id);
        return res.status(401).json({ message: 'User not found' });
      }

      next();
    } catch (error) {
      console.error('Auth middleware error:', error.message);
      res.status(401).json({ message: 'Not authorized, token failed' });
    }
  }

  if (!token) {
    console.log('Auth middleware: No token provided');
    res.status(401).json({ message: 'Not authorized, no token' });
  }
};

const admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({ message: 'Not authorized as an admin' });
  }
};

module.exports = { protect, admin };