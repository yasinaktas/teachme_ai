import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.primaryColor,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(AppDimensions.pagePadding),
      padding: EdgeInsets.only(
        top: AppDimensions.pagePadding / 2,
        bottom: AppDimensions.pagePadding / 2,
        left: AppDimensions.pagePadding,
        right: AppDimensions.pagePadding / 2,
      ),
      backgroundColor: backgroundColor,
      elevation: 2,
      showCloseIcon: true,
      closeIconColor: AppColors.textColorOnSurface,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      content: Text(message, style: AppStyles.textStyleNormalOnSurface),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class AppSuccessSnackBar extends AppSnackBar {
  static void show(BuildContext context, {required String message}) {
    AppSnackBar.show(context, message: message, backgroundColor: Colors.green);
  }
}

class AppErrorSnackBar extends AppSnackBar {
  static void show(BuildContext context, {required String message}) {
    AppSnackBar.show(context, message: message, backgroundColor: Colors.red);
  }
}
