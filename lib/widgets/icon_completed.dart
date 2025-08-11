import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class IconCompleted extends StatelessWidget {
  const IconCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryColor, width: 2.0),
      ),
      child: Icon(Icons.done, color: AppColors.primaryColor),
    );
  }
}
