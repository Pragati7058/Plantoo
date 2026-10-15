import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

enum GlassButtonType {
  primary,
  secondary,
}

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final GlassButtonType type;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = GlassButtonType.primary,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 56,
      child: widget.type == GlassButtonType.primary
          ? _buildPrimaryButton()
          : _buildSecondaryButton(),
    );
  }

  Widget _buildPrimaryButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryButtonGradient,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isPressed = true;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    setState(() {
                      _isPressed = false;
                    });
                  }
                });
                widget.onPressed();
              },
              borderRadius: BorderRadius.circular(50),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.deepestBackground,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: AppColors.deepestBackground,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: const TextStyle(
                              color: AppColors.deepestBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.glassOverlay(opacity: 0.06),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.glassBorder(opacity: 0.25),
                    width: 1,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isPressed = true;
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (mounted) {
                        setState(() {
                          _isPressed = false;
                        });
                      }
                    });
                    widget.onPressed();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accent,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
