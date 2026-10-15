import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (actionText != null)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onActionTap?.call();
                  },
                  child: Row(
                    children: [
                      Text(
                        actionText!,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.accent,
                        size: 16,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.lightText.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
