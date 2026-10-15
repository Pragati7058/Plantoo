import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/plant_product_card.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _recentSearches = ['Monstera', 'Fiddle Leaf', 'Snake Plant', 'Pothos'];

  @override
  Widget build(BuildContext context) {
    final searchResults = _getSearchResults();

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
                    if (_searchQuery.isEmpty) ...[
                      _buildRecentSearches(),
                      const SizedBox(height: 24),
                      _buildPopularSearches(),
                    ] else ...[
                      _buildSearchResults(searchResults),
                    ],
                    const SizedBox(height: 100),
                  ],
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
          const SizedBox(width: 12),
          Expanded(
            child: GlassTextField(
              hintText: 'Search plants...',
              controller: _searchController,
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _recentSearches.clear();
                });
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_recentSearches.isEmpty)
          Text(
            'No recent searches',
            style: TextStyle(
              color: AppColors.lightText.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _recentSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _searchController.text = search;
                  setState(() {
                    _searchQuery = search.toLowerCase();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.glassOverlay(opacity: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.glassBorder(opacity: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history,
                        color: AppColors.lightText,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        search,
                        style: const TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = ['Indoor Plants', 'Succulents', 'Air Purifying', 'Low Light'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: popularSearches.map((search) {
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _searchController.text = search;
                setState(() {
                  _searchQuery = search.toLowerCase();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.glassOverlay(opacity: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.glassBorder(opacity: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  search,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List _getSearchResults() {
    if (_searchQuery.isEmpty) return [];

    return MockData.plants.where((plant) =>
      plant.name.toLowerCase().contains(_searchQuery) ||
      plant.category.toLowerCase().contains(_searchQuery) ||
      plant.description.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  Widget _buildSearchResults(List results) {
    if (results.isEmpty) {
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
              'No results found',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results (${results.length})',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final plant = results[index];
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
              isWishlisted: false,
              onWishlistToggle: () {
                HapticFeedback.lightImpact();
              },
            );
          },
        ),
      ],
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
