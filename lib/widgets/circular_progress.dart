import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.circularProgressSizeSmall,
      height: AppDimensions.circularProgressSizeSmall,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: AppColors.primaryColor,
      ),
    );
  }
}
