import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/plant.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/care_info_chip.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Plant plant;

  const ProductDetailScreen({super.key, required this.plant});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: AnimatedBlobBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductImage(),
                    _buildProductInfo(),
                    _buildCareInfo(),
                    _buildDescription(),
                    const SizedBox(height: 160),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomBar(),
          GlassBottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              HapticFeedback.lightImpact();
              _handleNavigation(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _isWishlisted = !_isWishlisted;
                  });
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
                  child: Icon(
                    _isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: _isWishlisted ? Colors.red : AppColors.lightText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'plant_${widget.plant.id}',
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondarySurface.withValues(alpha: 0.5),
              AppColors.deepestBackground,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated circles around the plant
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating circle
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 20),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 6.28,
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Middle rotating circle (opposite direction)
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 15),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: -(value * 6.28),
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Inner pulsing circle
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1500),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 1 + (value * 0.1),
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Plant image
                    ClipOval(
                      child: Image.network(
                        widget.plant.imageUrl,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: const BoxDecoration(
                              color: AppColors.secondarySurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.eco,
                                size: 60,
                                color: AppColors.accent,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Floating particles
                    ...List.generate(6, (index) {
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 2000 + (index * 300)),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          final angle = (index / 6) * 6.28;
                          final radius = 140 + (value * 20);
                          return Positioned(
                            left: 140 + radius * cos(angle + value * 2),
                            top: 140 + radius * sin(angle + value * 2),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent.withValues(alpha: 0.6 - value * 0.4),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Gradient overlay at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.deepestBackground,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plant.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.plant.rating.toString(),
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.plant.reviews})',
                            style: TextStyle(
                              color: AppColors.lightText.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.8),
                        AppColors.accent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          color: AppColors.deepestBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.plant.price.toInt().toString(),
                        style: const TextStyle(
                          color: AppColors.deepestBackground,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.plant.category,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.plant.isPetFriendly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pets,
                          color: Colors.green,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Pet Friendly',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.plant.isInStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightText.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.lightText,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'In Stock',
                          style: TextStyle(
                            color: AppColors.lightText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Care Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CareInfoChip(
                icon: Icons.water_drop,
                label: 'Water',
                value: widget.plant.careInfo.water,
              ),
              CareInfoChip(
                icon: Icons.light_mode,
                label: 'Light',
                value: widget.plant.careInfo.light,
              ),
              CareInfoChip(
                icon: Icons.cloud,
                label: 'Humidity',
                value: widget.plant.careInfo.humidity,
              ),
              CareInfoChip(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: widget.plant.careInfo.temperature,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              widget.plant.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.deepestBackground.withValues(alpha: 0),
            AppColors.deepestBackground,
          ],
        ),
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildQuantityStepper(),
            const SizedBox(width: 16),
            Expanded(
              child: GlassButton(
                text: 'Add to Cart',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.plant.name} added to cart',
                        style: const TextStyle(color: AppColors.deepestBackground),
                      ),
                      backgroundColor: AppColors.accent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityStepper() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassOverlay(opacity: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorder(opacity: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (_quantity > 1) {
                setState(() {
                  _quantity--;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.remove,
                color: AppColors.lightText,
                size: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _quantity.toString(),
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _quantity++;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.add,
                color: AppColors.lightText,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/plants');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/care');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
