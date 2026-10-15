import '../models/plant.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/user.dart';
import '../models/notification.dart';

class MockData {
  static List<Plant> plants = [
    Plant(
      id: '1',
      name: 'Monstera Deliciosa',
      category: 'Indoor',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
      rating: 4.8,
      reviews: 124,
      description: 'The Monstera Deliciosa, also known as the Swiss Cheese Plant, is famous for its unique leaf holes. Perfect for adding tropical vibes to any indoor space.',
      careInfo: CareInfo(
        water: 'Weekly',
        light: 'Indirect',
        humidity: 'High',
        temperature: '65-85°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '2',
      name: 'Fiddle Leaf Fig',
      category: 'Indoor',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400',
      rating: 4.9,
      reviews: 89,
      description: 'A stunning statement plant with large, violin-shaped leaves. The Fiddle Leaf Fig is a favorite among interior designers.',
      careInfo: CareInfo(
        water: 'Every 10 days',
        light: 'Bright Indirect',
        humidity: 'Medium',
        temperature: '60-75°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '3',
      name: 'Snake Plant',
      category: 'Indoor',
      price: 35.00,
      imageUrl: 'https://images.unsplash.com/photo-1593482882270-f9b144448b75?w=400',
      rating: 4.7,
      reviews: 156,
      description: 'One of the easiest plants to care for, the Snake Plant is virtually indestructible and purifies air efficiently.',
      careInfo: CareInfo(
        water: 'Every 2-3 weeks',
        light: 'Low to Bright',
        humidity: 'Low',
        temperature: '60-85°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '4',
      name: 'Peace Lily',
      category: 'Indoor',
      price: 40.00,
      imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=400',
      rating: 4.6,
      reviews: 98,
      description: 'Elegant white flowers and lush green leaves make the Peace Lily a beautiful addition to any home. Excellent air purifier.',
      careInfo: CareInfo(
        water: 'Weekly',
        light: 'Low to Medium',
        humidity: 'High',
        temperature: '65-80°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '5',
      name: 'Pothos',
      category: 'Indoor',
      price: 25.00,
      imageUrl: 'https://images.unsplash.com/photo-1572688484438-313a6e50c333?w=400',
      rating: 4.8,
      reviews: 203,
      description: 'A trailing vine with heart-shaped leaves. Pothos is incredibly easy to grow and perfect for beginners.',
      careInfo: CareInfo(
        water: 'Every 1-2 weeks',
        light: 'Low to Bright',
        humidity: 'Medium',
        temperature: '60-85°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '6',
      name: 'Spider Plant',
      category: 'Indoor',
      price: 30.00,
      imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400',
      rating: 4.5,
      reviews: 87,
      description: 'Produces baby spiderettes that can be propagated. Great for hanging baskets and safe for pets.',
      careInfo: CareInfo(
        water: 'Weekly',
        light: 'Bright Indirect',
        humidity: 'Medium',
        temperature: '55-80°F',
      ),
      isPetFriendly: true,
    ),
    Plant(
      id: '7',
      name: 'Aloe Vera',
      category: 'Indoor',
      price: 28.00,
      imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
      rating: 4.7,
      reviews: 145,
      description: 'A succulent with medicinal properties. Aloe Vera is easy to care for and useful for treating minor burns.',
      careInfo: CareInfo(
        water: 'Every 3 weeks',
        light: 'Bright',
        humidity: 'Low',
        temperature: '55-80°F',
      ),
      isPetFriendly: false,
    ),
    Plant(
      id: '8',
      name: 'Rubber Plant',
      category: 'Indoor',
      price: 55.00,
      imageUrl: 'https://images.unsplash.com/photo-1612392064661-0d0b8a2d5c4e?w=400',
      rating: 4.6,
      reviews: 76,
      description: 'Bold, glossy leaves make the Rubber Plant a striking addition. Excellent air purifier and relatively low maintenance.',
      careInfo: CareInfo(
        water: 'Every 1-2 weeks',
        light: 'Medium to Bright',
        humidity: 'Medium',
        temperature: '60-80°F',
      ),
      isPetFriendly: false,
    ),
  ];

  static List<Category> categories = [
    Category(
      id: '1',
      name: 'All Plants',
      icon: 'leaf',
      plantCount: plants.length,
    ),
    Category(
      id: '2',
      name: 'Indoor',
      icon: 'home',
      plantCount: 8,
    ),
    Category(
      id: '3',
      name: 'Outdoor',
      icon: 'sun',
      plantCount: 5,
    ),
    Category(
      id: '4',
      name: 'Low Light',
      icon: 'moon',
      plantCount: 4,
    ),
    Category(
      id: '5',
      name: 'Pet Friendly',
      icon: 'heart',
      plantCount: 2,
    ),
  ];

  static List<CartItem> cartItems = [
    CartItem(
      id: '1',
      plantId: '1',
      plantName: 'Monstera Deliciosa',
      imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
      price: 45.00,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      plantId: '5',
      plantName: 'Pothos',
      imageUrl: 'https://images.unsplash.com/photo-1572688484438-313a6e50c333?w=400',
      price: 25.00,
      quantity: 2,
    ),
  ];

  static User currentUser = User(
    id: '1',
    name: 'Plant Lover',
    email: 'plantlover@plantoo.com',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    role: 'user',
  );

  static List<Notification> notifications = [
    Notification(
      id: '1',
      userId: '1',
      title: 'Order Shipped',
      message: 'Your Monstera Deliciosa has been shipped and will arrive in 2-3 days.',
      time: '2 hours ago',
      type: NotificationType.order,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      id: '2',
      userId: '1',
      title: 'Watering Reminder',
      message: 'Time to water your Snake Plant. It\'s been 2 weeks.',
      time: '5 hours ago',
      type: NotificationType.watering,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Notification(
      id: '3',
      userId: '1',
      title: 'Special Offer',
      message: 'Get 20% off on all indoor plants this weekend!',
      time: '1 day ago',
      type: NotificationType.promotion,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Notification(
      id: '4',
      userId: '1',
      title: 'New Arrival',
      message: 'Check out our new collection of rare tropical plants.',
      time: '2 days ago',
      type: NotificationType.general,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static List<String> recentSearches = [
    'Monstera',
    'Fiddle Leaf Fig',
    'Low light plants',
    'Pet friendly',
  ];
}
