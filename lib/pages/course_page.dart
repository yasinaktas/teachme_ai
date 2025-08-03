import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/widgets/course_page_course_card.dart';

class CoursePage extends StatelessWidget {
  final Course course;
  const CoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Enjoy Learning",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: CoursePageCourseCard(course: course)),
          SliverToBoxAdapter(
            child: Text(
              "Chapters",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ).withPadding(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chapter = course.chapters[index];
              return Card(
                color: AppColors.cardColor,
                elevation: AppDimensions.listCardElevation,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.listCardRadius,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/chapter",
                      arguments: chapter,
                    );
                  },
                  borderRadius: BorderRadius.circular(
                    AppDimensions.listCardRadius,
                  ),
                  child:
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primarySurfaceColor,
                          child: Text(
                            "${index + 1}",
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        title: Text(
                          chapter.title,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        subtitle: Text(
                          chapter.description,
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        trailing: chapter.isCompleted
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                child: Icon(
                                  Icons.done,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : Container(
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
                      ).withPadding(
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
                      ),
                ),
              ).withPadding();
            }, childCount: course.chapters.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom +
                  AppDimensions.pagePadding,
            ),
          ),
        ],
      ),
    );
  }
}
