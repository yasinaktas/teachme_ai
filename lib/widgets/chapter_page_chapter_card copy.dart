import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class ChapterPageChapterCard extends StatelessWidget {
  final Chapter chapter;
  const ChapterPageChapterCard({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                chapter.title,
                style: AppStyles.textStyleTitleOnSurface,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  chapter.description,
                  style: AppStyles.textStyleNormalOnSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    ).withPadding();
  }
}
