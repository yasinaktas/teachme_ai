import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final bool? hasDivider;
  final Function()? onTap;
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconSize = AppDimensions.iconSizeMedium,
    this.iconColor = AppColors.secondaryColor,
    this.hasDivider = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasDivider == true) Divider(color: AppColors.secondarySurfaceColor),
        ListTile(
          leading: Icon(icon, color: iconColor, size: iconSize),
          title: Text(title, style: AppStyles.textStyleNormalWeak),
          onTap: onTap,
        ),
      ],
    );
  }
}
