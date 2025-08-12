import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class TopBanner extends StatelessWidget {
  final String topText;
  final String bottomText;
  final String imagePath;
  final bool leftToRight;
  const TopBanner({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.imagePath,
    this.leftToRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primarySurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: BorderSide(color: AppColors.primaryShadowColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Row(
          children: [
            if (!leftToRight) ...[
              Image.asset(imagePath, height: 80),
              const Spacer(),
            ],
            Column(
              crossAxisAlignment: leftToRight
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(topText, style: AppStyles.textStyleLargeWeak),
                Text(bottomText, style: AppStyles.textStyleHeader),
              ],
            ),
            if (leftToRight) ...[
              const Spacer(),
              Image.asset(imagePath, height: 80),
            ],
          ],
        ),
      ),
    ).withPadding();
  }
}
