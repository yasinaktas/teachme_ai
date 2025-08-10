import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppExpansionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final List<Widget>? children;
  const AppExpansionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Icon(leadingIcon, color: AppColors.secondaryColor),
      ),
      title: Text(title, style: AppStyles.textStyleNormalLight),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(subtitle, style: AppStyles.textStyleLargeStrong),
      ),
      children: children ?? [],
    );
  }
}
