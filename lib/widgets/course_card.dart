import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.secondaryColor.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
      ),

      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/course", arguments: course);
        },
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(course.title),
                subtitle: Text(
                  course.description,
                  style: TextStyle(color: AppColors.secondaryColor),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircularProgressIndicator(
                    value:
                        course.chapters.fold(
                          0,
                          (value, chapter) =>
                              value += chapter.isCompleted ? 1 : 0,
                        ) /
                        course.chapters.length,
                    backgroundColor: AppColors.primaryShadowColor,
                    color: AppColors.primaryColor,
                    strokeWidth: 6.0,
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
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.secondaryColor,
                            size: 20,
                          ),
                          Text(
                            " ${course.createdAt.toLocal().toIso8601String().split('T')[0]}",
                            style: TextStyle(color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            color: AppColors.secondaryColor,
                            size: 20,
                          ),
                          Text(
                            "${course.chapters.fold(0, (value, chapter) => value += chapter.isCompleted ? 1 : 0)} / ${course.chapters.length} chapters",
                            style: TextStyle(color: AppColors.secondaryColor),
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
      ),
    ).withPadding();
  }
}
