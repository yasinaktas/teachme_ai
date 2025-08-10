import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/circular_progress.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class LoadingBar extends StatelessWidget {
  final String title;
  const LoadingBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      color: AppColors.primarySurfaceColor,
      elevation: 0,
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AppStyles.textStyleNormalLight),
              const SizedBox(width: AppDimensions.pagePadding),
              CircularProgress(),
            ],
          ).withPadding(
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePadding,
              vertical: AppDimensions.pagePadding / 2,
            ),
          ),
    );
  }
}
