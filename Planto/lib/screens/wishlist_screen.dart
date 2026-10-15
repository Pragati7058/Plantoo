import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/glass_card.dart';
import '../widgets/plant_product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistPlants = MockData.plants.take(3).toList();

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: AnimatedBlobBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SectionHeader(
                      title: 'My Wishlist',
                      subtitle: '${wishlistPlants.length} items',
                    ),
                    const SizedBox(height: 16),
                    _buildWishlistGrid(wishlistPlants),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          HapticFeedback.lightImpact();
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.glassOverlay(opacity: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.glassBorder(opacity: 0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.lightText,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Wishlist',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(List plants) {
    if (plants.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.lightText.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding plants you love!',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return PlantProductCard(
          plant: plant,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(plant: plant),
              ),
            );
          },
          isWishlisted: true,
          onWishlistToggle: () {
            HapticFeedback.lightImpact();
            setState(() {
              plants.remove(plant);
            });
          },
        );
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/plants');
        break;
      case 2:
        Navigator.pushNamed(context, '/care');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
