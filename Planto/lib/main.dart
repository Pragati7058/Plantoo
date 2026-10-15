import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'models/plant.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/plant_listing_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/plant_care_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/search_screen.dart';
import 'screens/address_screen.dart';
import 'screens/order_tracking_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const PlantooApp());
}

class PlantooApp extends StatelessWidget {
  const PlantooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plantoo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/plants':
            return MaterialPageRoute(builder: (_) => const PlantListingScreen());
          case '/product':
            final plant = settings.arguments;
            if (plant != null && plant is Plant) {
              return MaterialPageRoute(
                builder: (_) => ProductDetailScreen(plant: plant),
              );
            }
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/cart':
            return MaterialPageRoute(builder: (_) => const CartScreen());
          case '/checkout':
            return MaterialPageRoute(builder: (_) => const CheckoutScreen());
          case '/wishlist':
            return MaterialPageRoute(builder: (_) => const WishlistScreen());
          case '/care':
            return MaterialPageRoute(builder: (_) => const PlantCareScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsScreen());
          case '/search':
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case '/addresses':
            return MaterialPageRoute(builder: (_) => const AddressScreen());
          case '/order-tracking':
            final orderId = settings.arguments;
            if (orderId != null && orderId is String) {
              return MaterialPageRoute(
                builder: (_) => OrderTrackingScreen(orderId: orderId),
              );
            }
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
