const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Plant = require('./src/models/Plant');
const Category = require('./src/models/Category');
const User = require('./src/models/User');

dotenv.config();

// Comprehensive plant data with different categories
const plants = [
  // INDOOR PLANTS
  {
    name: 'Monstera Deliciosa',
    category: 'Indoor',
    price: 45.00,
    imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
    rating: 4.8,
    reviews: 124,
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
    imageUrl: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400',
    rating: 4.9,
    reviews: 89,
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
    imageUrl: 'https://images.unsplash.com/photo-1593482882270-f9b144448b75?w=400',
    rating: 4.7,
    reviews: 156,
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
    imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=400',
    rating: 4.6,
    reviews: 98,
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
    imageUrl: 'https://images.unsplash.com/photo-1572688484438-313a6e50c333?w=400',
    rating: 4.8,
    reviews: 203,
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
    imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400',
    rating: 4.5,
    reviews: 87,
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
  {
    name: 'Rubber Plant',
    category: 'Indoor',
    price: 55.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.6,
    reviews: 72,
    description: 'Bold, glossy leaves make the Rubber Plant a striking addition to any room. Excellent air purifier.',
    careInfo: {
      water: 'Every 1-2 weeks',
      light: 'Medium to Bright',
      humidity: 'Medium',
      temperature: '60-80°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'ZZ Plant',
    category: 'Indoor',
    price: 45.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.7,
    reviews: 95,
    description: 'Nearly indestructible with glossy, dark green leaves. Perfect for low-light environments and busy plant parents.',
    careInfo: {
      water: 'Every 2-3 weeks',
      light: 'Low to Bright',
      humidity: 'Low',
      temperature: '65-90°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },

  // OUTDOOR PLANTS
  {
    name: 'Lavender',
    category: 'Outdoor',
    price: 35.00,
    imageUrl: 'https://images.unsplash.com/photo-1499002238440-d264edd596ec?w=400',
    rating: 4.8,
    reviews: 145,
    description: 'Fragrant purple flowers that attract pollinators. Perfect for gardens and containers with soothing aroma.',
    careInfo: {
      water: 'When dry',
      light: 'Full Sun',
      humidity: 'Low',
      temperature: '60-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Rosemary',
    category: 'Outdoor',
    price: 28.00,
    imageUrl: 'https://images.unsplash.com/photo-1517941121650-9f9c0b8c8e4e?w=400',
    rating: 4.6,
    reviews: 89,
    description: 'Aromatic herb with needle-like leaves. Great for cooking and adds wonderful fragrance to outdoor spaces.',
    careInfo: {
      water: 'When dry',
      light: 'Full Sun',
      humidity: 'Low',
      temperature: '55-85°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Tomato Plant',
    category: 'Outdoor',
    price: 22.00,
    imageUrl: 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=400',
    rating: 4.5,
    reviews: 167,
    description: 'Homegrown tomatoes are delicious and rewarding. Perfect for vegetable gardens and large containers.',
    careInfo: {
      water: 'Daily',
      light: 'Full Sun',
      humidity: 'Medium',
      temperature: '65-85°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Basil',
    category: 'Outdoor',
    price: 18.00,
    imageUrl: 'https://images.unsplash.com/photo-1629157239878-717ef7aa6f74?w=400',
    rating: 4.7,
    reviews: 201,
    description: 'Fresh, aromatic herb essential for cooking. Easy to grow and produces abundant leaves.',
    careInfo: {
      water: 'Regular',
      light: 'Full Sun',
      humidity: 'Medium',
      temperature: '70-85°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Sunflower',
    category: 'Outdoor',
    price: 15.00,
    imageUrl: 'https://images.unsplash.com/photo-1551748653-81b9912ce464?w=400',
    rating: 4.9,
    reviews: 234,
    description: 'Cheerful, towering flowers that follow the sun. Great for gardens and attracting pollinators.',
    careInfo: {
      water: 'Regular',
      light: 'Full Sun',
      humidity: 'Medium',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Mint',
    category: 'Outdoor',
    price: 20.00,
    imageUrl: 'https://images.unsplash.com/photo-1517941121650-9f9c0b8c8e4e?w=400',
    rating: 4.6,
    reviews: 178,
    description: 'Fast-growing aromatic herb perfect for teas and cooking. Best grown in containers to control spread.',
    careInfo: {
      water: 'Regular',
      light: 'Part Shade to Full Sun',
      humidity: 'Medium',
      temperature: '55-75°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },

  // LOW LIGHT PLANTS
  {
    name: 'Cast Iron Plant',
    category: 'Low Light',
    price: 40.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.5,
    reviews: 67,
    description: 'Extremely tough plant that thrives in low light conditions. Perfect for dark corners and offices.',
    careInfo: {
      water: 'Every 2-3 weeks',
      light: 'Low',
      humidity: 'Low',
      temperature: '60-85°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Chinese Evergreen',
    category: 'Low Light',
    price: 38.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.6,
    reviews: 92,
    description: 'Colorful foliage with patterns that brighten up low-light spaces. Very forgiving and easy to care for.',
    careInfo: {
      water: 'Every 1-2 weeks',
      light: 'Low to Medium',
      humidity: 'Medium',
      temperature: '65-80°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Dracaena',
    category: 'Low Light',
    price: 42.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.4,
    reviews: 78,
    description: 'Tall, architectural plant with striking foliage. Excellent for adding height to low-light areas.',
    careInfo: {
      water: 'Every 2-3 weeks',
      light: 'Low to Medium',
      humidity: 'Low',
      temperature: '65-80°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Philodendron',
    category: 'Low Light',
    price: 32.00,
    imageUrl: 'https://images.unsplash.com/photo-1572688484438-313a6e50c333?w=400',
    rating: 4.7,
    reviews: 156,
    description: 'Easy-going trailing plant with heart-shaped leaves. Perfect for hanging baskets in low-light areas.',
    careInfo: {
      water: 'Every 1-2 weeks',
      light: 'Low to Bright',
      humidity: 'Medium',
      temperature: '60-80°F',
    },
    isPetFriendly: false,
    isInStock: true,
  },
  {
    name: 'Calathea',
    category: 'Low Light',
    price: 48.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.5,
    reviews: 84,
    description: 'Beautiful patterned leaves that move in response to light. Thrives in low to medium light.',
    careInfo: {
      water: 'Weekly',
      light: 'Low to Medium',
      humidity: 'High',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },

  // PET FRIENDLY PLANTS
  {
    name: 'Boston Fern',
    category: 'Pet Friendly',
    price: 35.00,
    imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400',
    rating: 4.6,
    reviews: 112,
    description: 'Lush, feathery fronds that add texture to any space. Safe for pets and excellent air purifier.',
    careInfo: {
      water: 'Keep moist',
      light: 'Indirect',
      humidity: 'High',
      temperature: '60-75°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Areca Palm',
    category: 'Pet Friendly',
    price: 55.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.7,
    reviews: 98,
    description: 'Graceful palm with feathery fronds. Non-toxic to pets and creates tropical atmosphere.',
    careInfo: {
      water: 'Weekly',
      light: 'Bright Indirect',
      humidity: 'High',
      temperature: '65-75°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Parlor Palm',
    category: 'Pet Friendly',
    price: 45.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.5,
    reviews: 76,
    description: 'Compact palm perfect for small spaces. Safe for pets and very easy to care for.',
    careInfo: {
      water: 'Weekly',
      light: 'Low to Bright',
      humidity: 'Medium',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Bamboo Palm',
    category: 'Pet Friendly',
    price: 50.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.6,
    reviews: 89,
    description: 'Elegant palm with bamboo-like stems. Excellent air purifier and safe for pets.',
    careInfo: {
      water: 'Weekly',
      light: 'Low to Bright',
      humidity: 'Medium',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'African Violet',
    category: 'Pet Friendly',
    price: 28.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.8,
    reviews: 134,
    description: 'Beautiful flowering plant that blooms year-round. Safe for pets and perfect for bright indoor spaces.',
    careInfo: {
      water: 'Keep moist',
      light: 'Bright Indirect',
      humidity: 'High',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
  {
    name: 'Prayer Plant',
    category: 'Pet Friendly',
    price: 38.00,
    imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
    rating: 4.7,
    reviews: 95,
    description: 'Fascinating plant with leaves that fold up at night. Non-toxic to pets and great conversation starter.',
    careInfo: {
      water: 'Weekly',
      light: 'Indirect',
      humidity: 'High',
      temperature: '65-80°F',
    },
    isPetFriendly: true,
    isInStock: true,
  },
];

const categories = [
  { name: 'All Plants', icon: 'leaf', plantCount: plants.length },
  { name: 'Indoor', icon: 'home', plantCount: plants.filter(p => p.category === 'Indoor').length },
  { name: 'Outdoor', icon: 'sun', plantCount: plants.filter(p => p.category === 'Outdoor').length },
  { name: 'Low Light', icon: 'moon', plantCount: plants.filter(p => p.category === 'Low Light').length },
  { name: 'Pet Friendly', icon: 'heart', plantCount: plants.filter(p => p.category === 'Pet Friendly').length },
];

const seedDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('MongoDB Atlas Connected');

    // Clear existing data
    await Plant.deleteMany();
    await Category.deleteMany();
    await User.deleteMany();

    console.log('Existing data cleared');

    // Insert sample data (without images - you'll add images separately)
    await Plant.insertMany(plants);
    await Category.insertMany(categories);

    // Create admin user
    const adminUser = await User.create({
      name: 'Admin User',
      email: 'admin@planto.com',
      password: 'admin123',
      role: 'admin',
    });

    console.log(`✅ ${plants.length} plants inserted`);
    console.log(`✅ ${categories.length} categories inserted`);
    console.log('✅ Admin user created: admin@planto.com / admin123');

    process.exit();
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
};

seedDatabase();
