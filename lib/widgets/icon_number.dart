import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class IconNumber extends StatelessWidget {
  final int index;
  const IconNumber({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primarySurfaceColor,
      child: Text("${index + 1}", style: AppStyles.textStyleNormalStrong),
    );
  }
}
