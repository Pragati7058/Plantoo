import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class GlassTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const GlassTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  void _handleFocus(bool focused) {
    setState(() {
      _isFocused = focused;
    });
    if (focused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _focusAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.glassOverlay(opacity: 0.05 + (_focusAnimation.value * 0.05)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.lerp(
                        AppColors.glassBorder(opacity: 0.15),
                        AppColors.accent,
                        _focusAnimation.value,
                      )!,
                      width: 0.8 + (_focusAnimation.value * 0.4),
                    ),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
            TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              maxLines: widget.maxLines,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              style: const TextStyle(
                color: AppColors.lightText,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: AppColors.lightText.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused ? AppColors.accent : AppColors.accent.withValues(alpha: 0.7),
                        size: 20,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          widget.suffixIcon,
                          color: _isFocused ? AppColors.accent : AppColors.accent.withValues(alpha: 0.7),
                          size: 20,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onSuffixIconPressed?.call();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onTap: () => _handleFocus(true),
              onFieldSubmitted: (_) => _handleFocus(false),
            ),
          ],
        ),
      ),
    );
  }
}
