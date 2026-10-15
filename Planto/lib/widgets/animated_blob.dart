import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Wraps a screen with a dark gradient base + slow-moving,
/// heavily-blurred color blobs drifting behind the glass UI.
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: AnimatedBlobBackground(
///     child: YourScreenContent(),
///   ),
/// )
/// ```
class AnimatedBlobBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBlobBackground({super.key, required this.child});

  @override
  State<AnimatedBlobBackground> createState() =>
      _AnimatedBlobBackgroundState();
}

class _AnimatedBlobBackgroundState extends State<AnimatedBlobBackground>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  final List<_BlobConfig> _blobs = [
    _BlobConfig(color: AppColors.accent, size: 260, seconds: 16, phase: 0.0),
    _BlobConfig(
        color: AppColors.elevatedSurface, size: 220, seconds: 22, phase: 2.1),
    _BlobConfig(
        color: AppColors.secondarySurface, size: 300, seconds: 28, phase: 4.4),
    _BlobConfig(color: AppColors.accent, size: 180, seconds: 20, phase: 1.3),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = _blobs
        .map(
          (b) => AnimationController(
            vsync: this,
            duration: Duration(seconds: b.seconds),
          )..repeat(),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
        ),

        // Floating blurred blobs
        Positioned.fill(
          child: RepaintBoundary(
            child: Stack(
              children: List.generate(_blobs.length, (i) {
                final blob = _blobs[i];
                return AnimatedBuilder(
                  animation: _controllers[i],
                  builder: (context, _) {
                    final t = _controllers[i].value * 2 * pi + blob.phase;
                    // organic figure-8-ish drift
                    final dx = sin(t) * size.width * 0.22;
                    final dy = cos(t * 0.7) * size.height * 0.12;
                    final baseLeft =
                        size.width * (0.15 + (i * 0.22) % 0.7) - blob.size / 2;
                    final baseTop =
                        size.height * (0.1 + (i * 0.2) % 0.6) - blob.size / 2;

                    return Positioned(
                      left: baseLeft + dx,
                      top: baseTop + dy,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 90,
                          sigmaY: 90,
                        ),
                        child: Container(
                          width: blob.size,
                          height: blob.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: blob.color.withValues(alpha: 0.32),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),

        // Actual UI content on top
        widget.child,
      ],
    );
  }
}

class _BlobConfig {
  final Color color;
  final double size;
  final int seconds;
  final double phase;

  _BlobConfig({
    required this.color,
    required this.size,
    required this.seconds,
    required this.phase,
  });
}