import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';

class SubscriptionChoice extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget mainContent;
  final bool isSelected;
  const SubscriptionChoice({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mainContent,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePadding,
          vertical: AppDimensions.pagePadding / 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySurfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : Border.all(color: AppColors.primaryShadowColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                title,
                Spacer(),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primaryDarkColor,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.pagePadding / 2),
            subtitle,
            SizedBox(height: AppDimensions.pagePadding / 4),
            mainContent,
          ],
        ),
      ).asExpanded(),
    );
  }
}
