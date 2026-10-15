import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CareInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const CareInfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassOverlay(opacity: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.glassBorder(opacity: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.lightText.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
