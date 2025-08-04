import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      elevation: AppDimensions.listCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
      ),

      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/course", arguments: course.id);
        },
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  course.title,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    course.description,
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryColor,
                    ),
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
                    color: AppColors.secondaryShadowColor,
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 52,
                        height: 52,
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
                          strokeWidth: 4.0,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${(course.chapters.fold(0, (value, chapter) => value += chapter.isCompleted ? 1 : 0) / course.chapters.length * 100).toStringAsFixed(0)}%",
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDarkColor,
                            ),
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
