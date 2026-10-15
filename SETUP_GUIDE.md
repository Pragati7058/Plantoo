# Planto - Professional E-Commerce App Setup Guide

## Overview
This is a fully functional plant e-commerce application with real database integration, Razorpay payment processing, address management, and order tracking.

## Features Implemented
- ✅ Real MongoDB database integration
- ✅ User authentication with JWT
- ✅ Product catalog with real plant data
- ✅ Shopping cart functionality
- ✅ Address management system
- ✅ Razorpay payment integration
- ✅ Order tracking with timeline
- ✅ Professional UI with glassmorphism design
- ✅ Responsive design
- ✅ Real-time notifications

## Backend Setup (Node.js + Express + MongoDB)

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (Atlas or local)
- Razorpay account (for payment processing)

### Installation Steps

1. **Navigate to backend directory**
   ```bash
   cd Planto-backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```
   *Note: If you encounter PowerShell script execution errors, run:*
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Configure environment variables**
   - The `.env` file is already configured with:
     - MongoDB connection string
     - JWT secret
     - Razorpay test keys
   
   - **For production**, update these values:
     ```
     RAZORPAY_KEY_ID=your_production_key_id
     RAZORPAY_KEY_SECRET=your_production_secret
     ```

4. **Seed the database**
   ```bash
   npm run seed
   ```
   This will populate the database with sample plants and create an admin user:
   - Email: `admin@planto.com`
   - Password: `admin123`

5. **Start the server**
   ```bash
   npm start
   ```
   Or for development with auto-reload:
   ```bash
   npm run dev
   ```

The backend will run on `http://localhost:5000`

## Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / Xcode
- For Android: Android SDK
- For iOS: Xcode (Mac only)

### Installation Steps

1. **Navigate to Flutter directory**
   ```bash
   cd Planto
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   - Edit `lib/services/api_client.dart`
   - Update the `baseUrl` to match your backend URL:
     ```dart
     static const String baseUrl = 'http://YOUR_IP:5000/api';
     ```
   - For testing on emulator, use `http://10.0.2.2:5000/api`
   - For physical device, use your computer's IP address

4. **Configure Razorpay**
   - Edit `lib/screens/checkout_screen.dart`
   - Update the Razorpay key:
     ```dart
     'key': 'YOUR_RAZORPAY_KEY_ID',
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Products
- `GET /api/plants` - Get all plants
- `GET /api/plants/:id` - Get single plant

### Cart
- `GET /api/cart` - Get user cart
- `POST /api/cart` - Add item to cart
- `PUT /api/cart/:itemId` - Update cart item
- `DELETE /api/cart/:itemId` - Remove item from cart
- `DELETE /api/cart` - Clear cart

### Orders
- `POST /api/orders` - Create order
- `GET /api/orders` - Get user orders
- `GET /api/orders/:id` - Get single order

### Payments
- `POST /api/payment/create-order` - Create Razorpay order
- `POST /api/payment/verify` - Verify payment

### Addresses
- `GET /api/addresses` - Get user addresses
- `POST /api/addresses` - Add new address
- `PUT /api/addresses/:id` - Update address
- `DELETE /api/addresses/:id` - Delete address
- `PUT /api/addresses/:id/default` - Set default address

## Database Schema

### User
- name, email, password
- addresses (array with default flag)
- role (user/admin)

### Plant
- name, category, price, imageUrl
- rating, reviews, description
- careInfo (water, light, humidity, temperature)
- isPetFriendly, isInStock

### Order
- user, items (array)
- totalAmount, status
- shippingAddress
- paymentInfo (paymentId, orderId, signature, status)
- tracking (trackingNumber, carrier, estimatedDelivery, history)

### CartItem
- user, plant, plantName, imageUrl
- price, quantity

## Razorpay Setup

### Test Mode
1. Sign up at [Razorpay](https://razorpay.com)
2. Get test keys from Dashboard → Settings → API Keys
3. Update `.env` file with test keys
4. Use test payment methods for testing

### Production
1. Get production keys from Razorpay dashboard
2. Update `.env` and Flutter checkout screen
3. Ensure your domain is whitelisted in Razorpay

## Testing the App

### 1. User Registration
- Open the app
- Register a new account
- Login with credentials

### 2. Browse Products
- View plant catalog
- Check plant details
- Add to cart

### 3. Address Management
- Go to Profile → Addresses
- Add shipping address
- Set default address

### 4. Checkout Process
- Go to cart
- Proceed to checkout
- Select address
- Complete payment with Razorpay
- View order confirmation

### 5. Order Tracking
- Go to Profile → My Orders
- Select an order
- View tracking timeline
- Check payment status

## Troubleshooting

### Backend Issues
- **MongoDB Connection**: Check your connection string in `.env`
- **Port Already in Use**: Change PORT in `.env`
- **Razorpay Errors**: Verify your API keys

### Frontend Issues
- **API Connection**: Ensure backend is running and URL is correct
- **Payment Errors**: Check Razorpay key in checkout screen
- **Build Errors**: Run `flutter clean` then `flutter pub get`

### Common Issues
- **Emulator Network**: Use `10.0.2.2` instead of `localhost`
- **iOS Build**: Ensure Xcode is properly configured
- **Android Build**: Check Android SDK and emulator

## Security Notes

⚠️ **Important for Production:**
1. Change all default passwords and secrets
2. Use environment variables for sensitive data
3. Enable HTTPS for production
4. Implement rate limiting
5. Add input validation
6. Use production Razorpay keys
7. Enable CORS properly
8. Implement proper error handling

## Deployment

### Backend (Heroku/Render)
1. Push code to Git
2. Connect to deployment platform
3. Set environment variables
4. Deploy and test

### Frontend (Play Store/App Store)
1. Build release APK/AAB
2. Test on physical devices
3. Prepare store listings
4. Submit for review

## Support

For issues or questions:
- Check API endpoints in `src/routes/`
- Review database models in `src/models/`
- Check Flutter services in `lib/services/`

## License

This project is for educational purposes.
