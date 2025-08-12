import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/models/course.dart';

class CourseCompletionProgress extends StatelessWidget {
  final Course course;
  const CourseCompletionProgress({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final completedChaptersCount = course.chapters.fold(
      0,
      (value, chapter) => value += chapter.isCompleted ? 1 : 0,
    );
    return Padding(
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
    );
  }
}
