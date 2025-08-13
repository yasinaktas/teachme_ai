import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;
  final bool isEnabled;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled,
      controller: widget.controller ?? TextEditingController(),
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && !_isVisible,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
        ),
        hintText: widget.hintText,
        hintStyle: AppStyles.textStyleNormalLight,
        suffixIcon: widget.isPassword
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.secondaryShadowColor,
                  ),
                ),
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}
