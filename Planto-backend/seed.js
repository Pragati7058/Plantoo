const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Plant = require('./src/models/Plant');
const Category = require('./src/models/Category');
const User = require('./src/models/User');

dotenv.config();

// Sample data
const plants = [
  {
    name: 'Monstera Deliciosa',
    category: 'Indoor',
    price: 45.00,
    rating: 4.8,
    reviews: 124,
    imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=800',
    description: 'The Monstera Deliciosa, also known as the Swiss Cheese Plant, is famous for its unique leaf holes. Perfect for adding tropical vibes to any indoor space.',
    careInfo: {
      water: 'Weekly',
      light: 'Indirect',
      humidity: 'High',
      temperature: '65-85°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Fiddle Leaf Fig',
    category: 'Indoor',
    price: 65.00,
    rating: 4.9,
    reviews: 89,
    imageUrl: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=800',
    description: 'A stunning statement plant with large, violin-shaped leaves. The Fiddle Leaf Fig is a favorite among interior designers.',
    careInfo: {
      water: 'Every 10 days',
      light: 'Bright Indirect',
      humidity: 'Medium',
      temperature: '60-75°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Snake Plant',
    category: 'Indoor',
    price: 35.00,
    rating: 4.7,
    reviews: 156,
    imageUrl: 'https://images.unsplash.com/photo-1593482892240-a2e27679342b?w=800',
    description: 'One of the easiest plants to care for, the Snake Plant is virtually indestructible and purifies air efficiently.',
    careInfo: {
      water: 'Every 2-3 weeks',
      light: 'Low to Bright',
      humidity: 'Low',
      temperature: '60-85°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Peace Lily',
    category: 'Indoor',
    price: 40.00,
    rating: 4.6,
    reviews: 98,
    imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=800',
    description: 'Elegant white flowers and lush green leaves make the Peace Lily a beautiful addition to any home. Excellent air purifier.',
    careInfo: {
      water: 'Weekly',
      light: 'Low to Medium',
      humidity: 'High',
      temperature: '65-80°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Pothos',
    category: 'Indoor',
    price: 25.00,
    rating: 4.8,
    reviews: 203,
    imageUrl: 'https://images.unsplash.com/photo-1597055181300-e30ba15459c3?w=800',
    description: 'A trailing vine with heart-shaped leaves. Pothos is incredibly easy to grow and perfect for beginners.',
    careInfo: {
      water: 'Every 1-2 weeks',
      light: 'Low to Bright',
      humidity: 'Medium',
      temperature: '60-85°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Spider Plant',
    category: 'Indoor',
    price: 30.00,
    rating: 4.5,
    reviews: 87,
    imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=800',
    description: 'Produces baby spiderettes that can be propagated. Great for hanging baskets and safe for pets.',
    careInfo: {
      water: 'Weekly',
      light: 'Bright Indirect',
      humidity: 'Medium',
      temperature: '55-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
];

const categories = [
  { name: 'All Plants', icon: 'leaf', plantCount: 6 },
  { name: 'Indoor', icon: 'home', plantCount: 6 },
  { name: 'Outdoor', icon: 'sun', plantCount: 0 },
  { name: 'Low Light', icon: 'moon', plantCount: 3 },
  { name: 'Pet Friendly', icon: 'heart', plantCount: 1 },
];

const seedDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('MongoDB Connected');

    // Clear existing data
    await Plant.deleteMany();
    await Category.deleteMany();
    await User.deleteMany();

    console.log('Data cleared');

    // Insert sample data
    await Plant.insertMany(plants);
    await Category.insertMany(categories);

    // Create admin user
    const adminUser = await User.create({
      name: 'Admin User',
      email: 'admin@planto.com',
      password: 'admin123',
      role: 'admin',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    });

    console.log('Sample data inserted');
    console.log('Admin user created: admin@planto.com / admin123');

    process.exit();
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
};

seedDatabase();