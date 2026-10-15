import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../models/plant.dart';
import '../models/category.dart';
import '../services/plant_service.dart';
import '../services/cart_service.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/plant_product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_bottom_nav_bar.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _cartItemCount = 0;
  List<Plant> _plants = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<Category> _categories = [
    Category(id: '1', name: 'All', icon: 'leaf', plantCount: 0),
    Category(id: '2', name: 'Indoor', icon: 'home', plantCount: 0),
    Category(id: '3', name: 'Outdoor', icon: 'sun', plantCount: 0),
    Category(id: '4', name: 'Succulents', icon: 'moon', plantCount: 0),
    Category(id: '5', name: 'Herbs', icon: 'heart', plantCount: 0),
  ];

  @override
  void initState() {
    super.initState();
    _loadPlants();
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    final response = await CartService.getCart();
    if (response['success'] == true && response['items'] != null) {
      final items = response['items'] as List;
      setState(() {
        _cartItemCount = items.length;
      });
    }
  }

  Future<void> _loadPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final category = _selectedCategoryIndex == 0 ? null : _categories[_selectedCategoryIndex].name;
      final result = await PlantService.getPlants(category: category);
      
      if (result['success'] == true && result['data'] != null) {
        final plantsData = result['data'] as List;
        setState(() {
          _plants = plantsData.map((json) => Plant.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load plants';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading plants: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildHeroBanner(),
                      const SizedBox(height: 24),
                      _buildCategories(),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: 'Best Sellers',
                        actionText: 'View All',
                        onActionTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildBestSellers(),
                      const SizedBox(height: 100), // clears the floating nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          HapticFeedback.lightImpact();
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final iconSize = constraints.maxWidth < 600 ? 20.0 : 24.0;
          final fontSize = constraints.maxWidth < 600 ? 20.0 : 24.0;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: EdgeInsets.all(constraints.maxWidth < 600 ? 10 : 12),
                    decoration: BoxDecoration(
                      color: AppColors.glassOverlay(opacity: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.glassBorder(opacity: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: AppColors.lightText,
                      size: iconSize,
                    ),
                  ),
                ),
                Text(
                  'Plantoo',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Container(
                    padding: EdgeInsets.all(constraints.maxWidth < 600 ? 10 : 12),
                    decoration: BoxDecoration(
                      color: AppColors.glassOverlay(opacity: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.glassBorder(opacity: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: AppColors.lightText,
                          size: iconSize,
                        ),
                        if (_cartItemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _cartItemCount.toString(),
                                style: const TextStyle(
                                  color: AppColors.deepestBackground,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassTextField(
      hintText: 'Search plants...',
      prefixIcon: Icons.search,
      suffixIcon: Icons.filter_list,
      onSuffixIconPressed: () {
        HapticFeedback.lightImpact();
      },
    );
  }

  Widget _buildHeroBanner() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bring Greenery to Life',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Discover our curated collection of beautiful plants for your home',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightText.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: AppColors.buttonShadow,
                  ),
                  child: const Center(
                    child: Text(
                      'Shop Now',
                      style: TextStyle(
                        color: AppColors.deepestBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == _categories.length - 1 ? 0 : 12,
            ),
            child: CategoryChip(
              category: _categories[index],
              isSelected: _selectedCategoryIndex == index,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedCategoryIndex = index;
                });
                _loadPlants();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBestSellers() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            const Text(
              'Error loading plants',
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlants,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_plants.isEmpty) {
      return const Center(
        child: Text(
          'No plants available',
          style: TextStyle(
            color: AppColors.lightText,
            fontSize: 16,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 600 ? 160.0 : 180.0;
        final cardHeight = constraints.maxWidth < 600 ? 260.0 : 280.0;
        
        final displayPlants = _plants.take(4).toList();
        
        return SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayPlants.length,
            itemBuilder: (context, index) {
              final plant = displayPlants[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == displayPlants.length - 1 ? 0 : 16,
                ),
                child: SizedBox(
                  width: cardWidth,
                  child: PlantProductCard(
                    key: ValueKey(plant.id),
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
                    isWishlisted: false,
                    onWishlistToggle: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/plants');
        break;
      case 2:
        Navigator.pushNamed(context, '/care');
        break;
      case 3:
        Navigator.pushNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}