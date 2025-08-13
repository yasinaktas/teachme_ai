import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppChoiceChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isEnabled;
  final Color? backgroundColor;
  final ValueChanged<bool>? onSelected;

  const AppChoiceChip({
    super.key,
    required this.text,
    required this.isSelected,
    this.isEnabled = true,
    this.backgroundColor,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        text,
        style: AppStyles.textStyleNormal.copyWith(
          color: isSelected
              ? AppColors.textColorOnSurface
              : AppColors.textColorLight,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      disabledColor: backgroundColor ?? AppColors.backgroundColor,
      selectedColor: AppColors.primaryColor,
      showCheckmark: false,
      selected: isSelected,
      onSelected: isEnabled ? onSelected : null,
    );
  }
}
