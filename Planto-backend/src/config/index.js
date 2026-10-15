const connectDB = require('./database');
const authConfig = require('./auth');

module.exports = {
  connectDB,
  ...authConfig,
};