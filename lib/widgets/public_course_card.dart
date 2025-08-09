import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class PublicCourseCard extends StatelessWidget {
  final Course course;
  const PublicCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  course.title,
                  style: AppStyles.textStyleLargeStrong,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    course.description,
                    style: AppStyles.textStyleSmallLight,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Divider(
              color: AppColors.secondaryShadowColor,
              thickness: 0.5,
              indent: 8,
              endIndent: 8,
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          color: AppColors.secondaryColor,
                          size: 20,
                        ),
                        Text(
                          "${course.chapters.length} chapters",
                          style: AppStyles.textStyleNormalLight,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 24,
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: AppColors.secondaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
