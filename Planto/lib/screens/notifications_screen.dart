import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/notification.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glass_bottom_nav_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
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
                      title: 'Notifications',
                      actionText: 'Mark all read',
                      onActionTap: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    const SizedBox(height: 16),
                    ...MockData.notifications.map((notification) => _buildNotificationItem(notification)),
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
          const SizedBox(width: 16),
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(notification) {
    IconData icon;
    Color iconColor;

    if (notification.type == NotificationType.order) {
      icon = Icons.shopping_bag;
      iconColor = AppColors.accent;
    } else if (notification.type == NotificationType.promotion) {
      icon = Icons.local_offer;
      iconColor = Colors.orange;
    } else if (notification.type == NotificationType.watering) {
      icon = Icons.water_drop;
      iconColor = Colors.blue;
    } else {
      icon = Icons.info;
      iconColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        onTap: () {
          HapticFeedback.lightImpact();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: AppColors.lightText.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification.time),
                    style: TextStyle(
                      color: AppColors.lightText.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
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
