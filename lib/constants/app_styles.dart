import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

class AppStyles {
  static TextStyle _base({
    double size = 14,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.textColor,
  }) {
    return GoogleFonts.quicksand(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  static final textStyleSmall = _base(size: AppDimensions.smallFontSize);
  static final textStyleNormal = _base(size: AppDimensions.normalFontSize);
  static final textStyleLarge = _base(size: AppDimensions.largeFontSize);
  static final textStyleTitle = _base(size: AppDimensions.titleFontSize);
  static final textStyleHeader = _base(size: AppDimensions.headerFontSize);

  static final textStyleSmallPrimary = _base(
    size: AppDimensions.smallFontSize,
    color: AppColors.primaryColor,
  );
  static final textStyleNormalPrimaryDark = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.primaryDarkColor,
  );
  static final textStyleLargePrimary = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.primaryColor,
  );

  static final textStyleSmallStrong = _base(
    size: AppDimensions.smallFontSize,
    color: AppColors.textColorStrong,
  );
  static final textStyleNormalStrong = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.textColorStrong,
  );
  static final textStyleLargeStrong = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.textColorStrong,
  );
  static final textStyleTitleStrong = _base(
    size: AppDimensions.titleFontSize,
    color: AppColors.textColorStrong,
  );

  static final textStyleSmallWeak = _base(
    size: AppDimensions.smallFontSize,
    color: AppColors.textColorWeak,
  );
  static final textStyleNormalWeak = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.textColorWeak,
  );
  static final textStyleLargeWeak = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.textColorWeak,
  );
  static final textStyleTitleWeak = _base(
    size: AppDimensions.titleFontSize,
    color: AppColors.textColorWeak,
  );

  static final textStyleSmallLight = _base(
    size: AppDimensions.smallFontSize,
    color: AppColors.textColorLight,
  );
  static final textStyleNormalLight = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.textColorLight,
  );
  static final textStyleLargeLight = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.textColorLight,
  );
  static final textStyleTitleLight = _base(
    size: AppDimensions.titleFontSize,
    color: AppColors.textColorLight,
  );

  static final textStyleSmallOnSurface = _base(
    size: AppDimensions.smallFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.bold,
  );
  static final textStyleNormalOnSurfaceThin = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.w500,
  );
  static final textStyleNormalOnSurface = _base(
    size: AppDimensions.normalFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.w500,
  );
  static final textStyleLargeOnSurface = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.bold,
  );
  static final textStyleLargeOnSurfaceThin = _base(
    size: AppDimensions.largeFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.w500,
  );
  static final textStyleTitleOnSurface = _base(
    size: AppDimensions.titleFontSize,
    color: AppColors.textColorOnSurface,
    weight: FontWeight.bold,
  );

  static final textStylePageTitle = _base(
    size: AppDimensions.pageTitleFontSize,
    color: AppColors.textColorStrong,
    weight: FontWeight.w500,
  );
}
