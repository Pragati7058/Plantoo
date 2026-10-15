import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const double _barHeight = 64;
  static const double _centerSize = 62;
  static const int _centerIndex = 2; // which item gets the raised circle

  static const List<IconData> _icons = [
    LucideIcons.home,
    LucideIcons.leaf,
    LucideIcons.sprout, // center / featured item
    LucideIcons.bookmark,
    LucideIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      // respects the system nav / gesture bar instead of overlapping it
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? bottomInset + 8 : 16),
      child: SizedBox(
        height: _barHeight + (_centerSize / 2),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // --- Glass pill bar ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: _barHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.secondarySurface.withValues(alpha: 0.55),
                          AppColors.deepestBackground.withValues(alpha: 0.65),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.glassBorder(opacity: 0.28),
                        width: 1,
                      ),
                      boxShadow: AppColors.glassShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_icons.length, (index) {
                        if (index == _centerIndex) {
                          return const SizedBox(width: _centerSize);
                        }
                        return _SideNavItem(
                          icon: _icons[index],
                          isActive: currentIndex == index,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onTap(index);
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            // --- Raised center glass circle ---
            Positioned(
              bottom: _barHeight - (_centerSize / 2) - 2,
              child: _CenterNavItem(
                icon: _icons[_centerIndex],
                isActive: currentIndex == _centerIndex,
                size: _centerSize,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onTap(_centerIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final double size;
  final VoidCallback onTap;

  const _CenterNavItem({
    required this.icon,
    required this.isActive,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: isActive ? 1 : 0),
        duration: const Duration(milliseconds: 450),
        curve: Curves.elasticOut,
        builder: (context, t, child) {
          return Transform.scale(
            scale: 1.0 + (t * 0.12),
            child: Transform.translate(
              offset: Offset(0, -t * 3),
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.lightText, AppColors.accent],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.elevatedSurface.withValues(alpha: 0.9),
                      AppColors.secondarySurface,
                    ],
                  ),
            border: Border.all(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppColors.glassBorder(opacity: 0.3),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: isActive ? 0.55 : 0.12),
                blurRadius: isActive ? 22 : 10,
                spreadRadius: isActive ? 1 : 0,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isActive
                ? AppColors.deepestBackground
                : AppColors.lightText.withValues(alpha: 0.55),
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isActive ? 1 : 0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.elasticOut,
              builder: (context, t, child) {
                return Transform.scale(
                  scale: 1.0 + (t * 0.18),
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // soft glow behind the active icon
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isActive ? 1 : 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TweenAnimationBuilder<Color?>(
                    tween: ColorTween(
                      end: isActive
                          ? AppColors.accent
                          : AppColors.lightText.withValues(alpha: 0.4),
                    ),
                    duration: const Duration(milliseconds: 250),
                    builder: (context, color, _) {
                      return Icon(icon, size: 23, color: color);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isActive ? 14 : 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive
                    ? AppColors.accent
                    : Colors.transparent,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}