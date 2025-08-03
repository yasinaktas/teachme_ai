import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';

class CoursePageCourseCard extends StatelessWidget {
  final Course course;
  const CoursePageCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.primaryColor,
      elevation: AppDimensions.listCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                course.title,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  course.description,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
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
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          " ${course.createdAt.toLocal().toIso8601String().split('T')[0]}",
                          style: TextStyle(color: Colors.white),
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
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "${course.chapters.fold(0, (value, chapter) => value += chapter.isCompleted ? 1 : 0)} / ${course.chapters.length} chapters",
                          style: TextStyle(color: Colors.white),
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
