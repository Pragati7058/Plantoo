# Planto Backend API

Backend API for Planto - a plant e-commerce application.

## Features

- User authentication (JWT)
- Plant management (CRUD)
- Shopping cart
- Order management
- Wishlist functionality
- Notifications
- Categories and filtering

## Tech Stack

- Node.js + Express
- MongoDB + Mongoose
- JWT Authentication
- Bcrypt for password hashing

## Installation

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file:
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/planto
JWT_SECRET=your_jwt_secret_key_change_this_in_production
JWT_EXPIRE=30d
COOKIE_EXPIRE=30
NODE_ENV=development
```

3. Make sure MongoDB is running on your system

4. Seed the database with sample data:
```bash
npm run seed
```

This will create:
- 6 sample plants
- 5 categories
- 1 admin user (email: admin@planto.com, password: admin123)

## Running the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will run on `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (protected)

### Plants
- `GET /api/plants` - Get all plants (supports filtering)
- `GET /api/plants/:id` - Get single plant
- `POST /api/plants` - Create plant (admin only)
- `PUT /api/plants/:id` - Update plant (admin only)
- `DELETE /api/plants/:id` - Delete plant (admin only)

### Query Parameters for Plants
- `?category=Indoor` - Filter by category
- `?search=Monstera` - Search by name
- `?minPrice=20&maxPrice=50` - Filter by price range
- `?isPetFriendly=true` - Filter by pet-friendly plants

## Example Usage

### Register a new user
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","password":"password123"}'
```

### Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'
```

### Get all plants
```bash
curl http://localhost:5000/api/plants
```

### Get filtered plants
```bash
curl "http://localhost:5000/api/plants?category=Indoor&minPrice=20&maxPrice=50"
```

### Create plant (admin)
```bash
curl -X POST http://localhost:5000/api/plants \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name":"New Plant",
    "category":"Indoor",
    "price":45.00,
    "imageUrl":"https://example.com/image.jpg",
    "rating":4.5,
    "reviews":10,
    "description":"A beautiful plant",
    "careInfo":{
      "water":"Weekly",
      "light":"Indirect",
      "humidity":"Medium",
      "temperature":"65-80°F"
    },
    "isPetFriendly":false,
    "isInStock":true
  }'
```

## Project Structure

```
planto-backend/
├── src/
│   ├── config/          # Database and auth configuration
│   ├── models/          # Mongoose models
│   ├── controllers/     # Route controllers
│   ├── routes/          # API routes
│   ├── middleware/      # Custom middleware
│   ├── services/        # Business logic services
│   └── utils/          # Utility functions
├── seed.js             # Database seeding script
├── server.js           # Entry point
└── package.json
```

## Next Steps

The following features are ready to be implemented:
- Cart management
- Order processing
- Wishlist functionality
- Notification system
- Review system
- User profile management

Each follows the same pattern as the implemented authentication and plant management.