import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class CoursePageCourseCard extends StatelessWidget {
  final Course course;
  const CoursePageCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final completedChaptersCount = course.chapters.fold(
      0,
      (value, chapter) => value += chapter.isCompleted ? 1 : 0,
    );
    final createDate = course.createdAt.toLocal().toIso8601String().split(
      'T',
    )[0];
    return ListCard(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                course.title,
                style: AppStyles.textStyleTitleOnSurface,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  course.description,
                  style: AppStyles.textStyleNormalOnSurfaceThin,
                ),
              ),
            ),
            Divider(
              color: AppColors.onCardOppositeColor,
              thickness: 0.5,
              indent: AppDimensions.pagePadding / 2,
              endIndent: AppDimensions.pagePadding / 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.onCardOppositeColor,
                          size: AppDimensions.iconSizeSmall,
                        ),
                        Text(
                          " $createDate",
                          style: AppStyles.textStyleNormalOnSurfaceThin,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          color: AppColors.onCardOppositeColor,
                          size: AppDimensions.iconSizeSmall,
                        ),
                        Text(
                          "$completedChaptersCount / ${course.chapters.length} chapters",
                          style: AppStyles.textStyleNormalOnSurfaceThin,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).withPadding();
  }
}
