import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/models/course.dart';

class PublicCourseCard extends StatelessWidget {
  final Course course;
  const PublicCourseCard({super.key, required this.course});

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
          //Navigator.pushNamed(context, "/course", arguments: course);
        },
        borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListTile(
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
                ),
              ),
              Divider(
                color: AppColors.secondaryShadowColor,
                thickness: 0.5,
                indent: 8,
                endIndent: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 16.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Row(
                  children: [
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
                            "${course.chapters.length} chapters",
                            style: TextStyle(color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.bookmark_outline,
                        color: AppColors.secondaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
