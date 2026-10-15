import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';

class PlantCareScreen extends StatefulWidget {
  const PlantCareScreen({super.key});

  @override
  State<PlantCareScreen> createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
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
                    children: [
                      SectionHeader(
                        title: 'Care Schedule',
                        actionText: 'View All',
                        onActionTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildCareSchedule(),
                      const SizedBox(height: 24),
                      const SectionHeader(
                        title: 'Care Tips',
                      ),
                      const SizedBox(height: 16),
                      _buildCareTips(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          HapticFeedback.lightImpact();
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Plant Care',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  Widget _buildCareSchedule() {
    final scheduleItems = [
      {
        'icon': Icons.water_drop,
        'title': 'Watering',
        'subtitle': 'Monstera Deliciosa',
        'time': 'Today, 10:00 AM',
        'color': AppColors.accent,
      },
      {
        'icon': Icons.light_mode,
        'title': 'Sunlight Check',
        'subtitle': 'Fiddle Leaf Fig',
        'time': 'Tomorrow, 9:00 AM',
        'color': Colors.orange,
      },
      {
        'icon': Icons.eco,
        'title': 'Repotting',
        'subtitle': 'Snake Plant',
        'time': 'In 3 days',
        'color': Colors.green,
      },
    ];

    return Column(
      children: scheduleItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: AppColors.lightText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'] as String,
                        style: TextStyle(
                          color: AppColors.lightText.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['time'] as String,
                      style: TextStyle(
                        color: AppColors.lightText.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.glassOverlay(opacity: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCareTips() {
    final tips = [
      {
        'icon': Icons.water_drop,
        'title': 'Watering Guide',
        'description': 'Learn how to water your plants properly',
      },
      {
        'icon': Icons.light_mode,
        'title': 'Light Requirements',
        'description': 'Understanding light needs for different plants',
      },
      {
        'icon': Icons.thermostat,
        'title': 'Temperature Control',
        'description': 'Ideal temperature ranges for indoor plants',
      },
      {
        'icon': Icons.bug_report,
        'title': 'Pest Prevention',
        'description': 'Keep your plants healthy and pest-free',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return GlassCard(
          padding: const EdgeInsets.all(16),
          onTap: () {
            HapticFeedback.lightImpact();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                tip['icon'] as IconData,
                color: AppColors.accent,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                tip['title'] as String,
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tip['description'] as String,
                style: TextStyle(
                  color: AppColors.lightText.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
      case 3:
        Navigator.pushNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
