import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

class ListCard extends StatelessWidget {
  final Widget? child;
  final Function()? onTap;
  final Color? color;
  final double? elevation;
  final bool? hasBorder;
  const ListCard({
    super.key,
    this.child,
    this.onTap,
    this.color,
    this.elevation,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: color ?? AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
        side: hasBorder == true
            ? BorderSide(color: AppColors.secondaryShadowColor, width: 0.5)
            : BorderSide.none,
      ),
      elevation: elevation ?? AppDimensions.listCardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
