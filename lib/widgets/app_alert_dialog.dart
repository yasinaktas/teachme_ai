import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionButtonText;
  final Function? onActionButtonPressed;
  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionButtonText,
    this.onActionButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      title: Text(title, style: AppStyles.textStyleTitleStrong),
      content: Text(content, style: AppStyles.textStyleNormalLight),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: AppStyles.textStyleNormalPrimaryDark),
        ),
        TextButton(
          onPressed: () {
            if (onActionButtonPressed != null) {
              onActionButtonPressed!();
            }
            Navigator.of(context).pop();
          },
          child: Text(
            actionButtonText,
            style: AppStyles.textStyleNormalPrimaryDark,
          ),
        ),
      ],
    );
  }
}
