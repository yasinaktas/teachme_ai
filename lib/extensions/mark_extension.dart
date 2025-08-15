import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

extension MarkExtension on Widget {
  Widget asMarked({Color color = Colors.amberAccent}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePadding / 2,
        vertical: AppDimensions.pagePadding / 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusTiny),
      ),
      child: this,
    );
  }
}
