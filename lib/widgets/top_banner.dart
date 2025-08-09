import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusLarge),
        ),
        color: AppColors.primarySurfaceColor,
        border: Border.all(color: AppColors.primaryShadowColor),
      ),
      padding: EdgeInsets.all(AppDimensions.largePadding),
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
              Text(
                topText,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                ),
              ),
              Text(
                bottomText,
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          if (leftToRight) ...[
            const Spacer(),
            Image.asset(imagePath, height: 80),
          ],
        ],
      ),
    ).withPadding();
  }
}
