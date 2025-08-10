import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppElevatedButton extends StatelessWidget {
  final bool isActive;
  final String text;
  final Function() onPressed;
  final double? radius;
  final Color? backgroundColor;
  const AppElevatedButton({
    super.key,
    required this.isActive,
    required this.text,
    required this.onPressed,
    this.radius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: !isActive ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              radius ?? AppDimensions.buttonRadiusSmall,
            ),
          ),
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
        ),
        child: Text(text, style: AppStyles.textStyleNormalOnSurface),
      ),
    );
  }
}
