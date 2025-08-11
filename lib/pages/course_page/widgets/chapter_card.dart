import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/icon_completed.dart';
import 'package:teachme_ai/widgets/icon_forward.dart';
import 'package:teachme_ai/widgets/icon_number.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final int index;
  const ChapterCard({super.key, required this.chapter, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      onTap: () {
        Navigator.pushNamed(context, "/chapter", arguments: chapter);
      },
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: IconNumber(index: index),
        title: Text(chapter.title, style: AppStyles.textStyleNormalStrong),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            chapter.description,
            style: AppStyles.textStyleSmallLight,
          ),
        ),
        trailing: chapter.isCompleted
            ? const IconCompleted()
            : const IconForward(),
      ).withPadding(const EdgeInsets.symmetric(vertical: 8.0)),
    ).withPadding();
  }
}
