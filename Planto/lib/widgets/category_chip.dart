import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppColors.primaryButtonGradient
              : null,
          color: isSelected
              ? null
              : AppColors.glassOverlay(opacity: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.glassBorder(opacity: 0.3),
            width: 1,
          ),
          boxShadow: isSelected ? AppColors.buttonShadow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(category.icon),
              color: isSelected
                  ? AppColors.deepestBackground
                  : AppColors.accent,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected
                    ? AppColors.deepestBackground
                    : AppColors.lightText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'leaf':
        return LucideIcons.leaf;
      case 'home':
        return LucideIcons.home;
      case 'sun':
        return LucideIcons.sun;
      case 'moon':
        return LucideIcons.moon;
      case 'heart':
        return LucideIcons.heart;
      default:
        return LucideIcons.leaf;
    }
  }
}
