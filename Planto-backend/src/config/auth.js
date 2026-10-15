module.exports = {
  jwtSecret: process.env.JWT_SECRET || 'fallback_secret_key',
  jwtExpire: process.env.JWT_EXPIRE || '30d',
  cookieExpire: process.env.COOKIE_EXPIRE || 30,
};