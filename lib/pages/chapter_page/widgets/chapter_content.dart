import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class ChapterContent extends StatelessWidget {
  final String htmlContent;
  const ChapterContent({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    debugPrint(htmlContent);
    final titleStyle = Style(
      fontWeight: FontWeight.bold,
      fontSize: FontSize(20),
      color: AppColors.primaryColor,
    );
    return Html(
      data: htmlContent,
      style: {
        "h1": titleStyle,
        "h2": titleStyle,
        "h3": titleStyle,
        "h4": titleStyle,

        "p": Style(fontSize: FontSize(16), color: AppColors.textColor),
      },
      extensions: [MathHtmlExtension()],
    ).withPadding(
      const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePadding / 2,
        vertical: AppDimensions.pagePadding / 2,
      ),
    );
  }
}
