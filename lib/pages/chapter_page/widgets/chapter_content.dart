import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_math/flutter_html_math.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class ChapterContent extends StatelessWidget {
  final String htmlContent;
  const ChapterContent({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
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
        "h5": titleStyle,
        "h6": titleStyle,
        "p": Style(
          fontSize: FontSize(14),
          color: AppColors.textColor,
          fontFamily: GoogleFonts.quicksand().fontFamily,
        ),
      },
      extensions: [
        MathHtmlExtension(),
        TagExtension(
          tagsToExtend: {"code"},
          builder: (context) {
            final language =
                context.attributes['class']?.replaceAll('language-', '') ??
                'dart';
            final lineCount = context.innerHtml.split('\n').length;
            return lineCount == 1
                ? Text(
                    unescape.convert(context.innerHtml),
                    style: AppStyles.textStyleNormalWeak,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: HighlightView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16,
                      ),
                      context.innerHtml,
                      language: language,
                      theme: atomOneDarkTheme,
                      textStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ).asExpanded();
          },
        ),
      ],
    ).withPadding(
      const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePadding / 2,
        vertical: AppDimensions.pagePadding / 2,
      ),
    );
  }
}
