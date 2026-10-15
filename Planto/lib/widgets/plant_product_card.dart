import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/plant.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class PlantProductCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback? onWishlistToggle;
  final bool isWishlisted;

  const PlantProductCard({
    super.key,
    required this.plant,
    required this.onTap,
    this.onWishlistToggle,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      enableGlossyEffect: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    plant.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.secondarySurface,
                              AppColors.deepestBackground,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.leaf,
                            color: AppColors.accent,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient overlay for better text readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.deepestBackground.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Wishlist button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onWishlistToggle?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.glassOverlay(opacity: 0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.glassBorder(opacity: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isWishlisted ? LucideIcons.heart : LucideIcons.heart,
                        color: isWishlisted
                            ? Colors.red
                            : AppColors.lightText,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      plant.category,
                      style: const TextStyle(
                        color: AppColors.deepestBackground,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.name,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.star,
                            color: AppColors.accent,
                            size: 11,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            plant.rating.toString(),
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${plant.reviews} reviews',
                      style: TextStyle(
                        color: AppColors.lightText.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${plant.price.toInt()}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.plus,
                        color: AppColors.deepestBackground,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
