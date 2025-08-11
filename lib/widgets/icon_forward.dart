import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class IconForward extends StatelessWidget {
  const IconForward({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryShadowColor, width: 2.0),
      ),
      child: Icon(
        Icons.keyboard_arrow_right,
        color: AppColors.secondaryShadowColor,
      ),
    );
  }
}
