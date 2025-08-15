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
  final bool isMultiline;
  final Widget? hint;
  final Function(String)? onChanged;
  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isEnabled = true,
    this.isMultiline = false,
    this.hint,
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
      minLines: widget.isMultiline ? 3 : 1,
      maxLines: widget.isMultiline ? null : 1,
      cursorColor: AppColors.primaryColor,
      autocorrect: false,
      style: AppStyles.textStyleNormalWeak,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: BorderSide(color: AppColors.primaryDarkColor, width: 1.5),
        ),
        hint:
            widget.hint ??
            Text(widget.hintText, style: AppStyles.textStyleNormalLight),
        //hintText: widget.hintText,
        //hintStyle: AppStyles.textStyleNormalLight,
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
