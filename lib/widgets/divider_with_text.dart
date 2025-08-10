import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class DividerWithText extends StatelessWidget {
  final String title;
  const DividerWithText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.secondaryShadowColor,
            thickness: 0.5,
            indent: AppDimensions.pagePadding,
            endIndent: AppDimensions.pagePadding,
          ),
        ),
        Text(title, style: AppStyles.textStyleLargeLight).withPadding(
          EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePadding / 2,
            vertical: AppDimensions.pagePadding / 2,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.secondaryShadowColor,
            thickness: 0.5,
            indent: AppDimensions.pagePadding,
            endIndent: AppDimensions.pagePadding,
          ),
        ),
      ],
    );
  }
}
