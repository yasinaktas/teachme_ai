import 'package:flutter/widgets.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

extension PaddingExtension on Widget {
  Widget withPadding([
    EdgeInsets padding = const EdgeInsets.only(
      left: AppDimensions.pagePadding,
      right: AppDimensions.pagePadding,
      top: AppDimensions.pagePadding,
    ),
  ]) {
    return Padding(padding: padding, child: this);
  }
}
