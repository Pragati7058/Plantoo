import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/plant.dart';
import '../theme/app_colors.dart';
import '../models/category.dart';
import '../services/plant_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/category_chip.dart';
import '../widgets/plant_product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';
import 'product_detail_screen.dart';

class PlantListingScreen extends StatefulWidget {
  const PlantListingScreen({super.key});

  @override
  State<PlantListingScreen> createState() => _PlantListingScreenState();
}

class _PlantListingScreenState extends State<PlantListingScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
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
  }

  Future<void> _loadPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final category = _selectedCategoryIndex == 0 ? null : _categories[_selectedCategoryIndex].name;
      final result = await PlantService.getPlants(
        category: category,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
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

  List<Plant> _getFilteredPlants() {
    if (_searchQuery.isEmpty) return _plants;
    return _plants.where((plant) => 
      plant.name.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlants = _getFilteredPlants();

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
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildCategories(),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: 'All Plants',
                      subtitle: '${filteredPlants.length} items',
                    ),
                    const SizedBox(height: 16),
                    _buildPlantGrid(filteredPlants),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 1,
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
            'Plants',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassTextField(
      hintText: 'Search plants...',
      prefixIcon: Icons.search,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        _loadPlants();
      },
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

  Widget _buildPlantGrid(List<Plant> plants) {
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

    if (plants.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.lightText.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No plants found',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 16,
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
        );
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
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
