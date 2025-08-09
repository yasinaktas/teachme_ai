import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

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
      onTap: () {
        Navigator.pushNamed(context, "/course", arguments: course.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
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
              trailing: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondaryShadowColor,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: AppDimensions.iconSizeMedium,
                  color: AppColors.secondaryShadowColor,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    SizedBox(
                      width: AppDimensions.circularProgressSizeLarge,
                      height: AppDimensions.circularProgressSizeLarge,
                      child: CircularProgressIndicator(
                        value: course.chapters.isEmpty
                            ? 0
                            : completedChaptersCount / course.chapters.length,
                        backgroundColor: AppColors.primaryShadowColor,
                        color: AppColors.primaryColor,
                        strokeWidth: 4.0,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${(completedChaptersCount / course.chapters.length * 100).toStringAsFixed(0)}%",
                          style: AppStyles.textStyleSmallPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.secondaryShadowColor,
              thickness: 0.5,
              indent: 8,
              endIndent: 8,
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
                          color: AppColors.secondaryColor,
                          size: AppDimensions.iconSizeSmall,
                        ),
                        Text(
                          " $createDate",
                          style: AppStyles.textStyleNormalLight,
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
                          color: AppColors.secondaryColor,
                          size: AppDimensions.iconSizeSmall,
                        ),
                        Text(
                          "$completedChaptersCount / ${course.chapters.length} chapters",
                          style: AppStyles.textStyleNormalLight,
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
