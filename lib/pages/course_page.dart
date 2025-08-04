import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/widgets/course_page_course_card.dart';

class CoursePage extends StatelessWidget {
  final String courseId;
  const CoursePage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        Course? course;
        for (var c in state.courses) {
          if (c.id == courseId) {
            course = c;
            break;
          }
        }
        return course == null
            ? Center(
                child: Text(
                  "Course not found",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor,
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  backgroundColor: AppColors.backgroundColor,
                  scrolledUnderElevation: 0,
                  centerTitle: true,
                  title: Text(
                    "Enjoy Learning",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      color: AppColors.backgroundColor,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'delete',
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('Delete Course'),
                            ),
                          ),
                        ];
                      },
                      icon: Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete Course'),
                                content: Text(
                                  'Are you sure you want to delete this course?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<CourseBloc>(
                                        context,
                                      ).add(CourseDeleteEvent(course!.id));
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        "Course Summary",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ).withPadding(),
                    ),
                    SliverToBoxAdapter(
                      child: CoursePageCourseCard(course: course),
                    ),
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
                        final chapter = course!.chapters[index];
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
                                    backgroundColor:
                                        AppColors.primarySurfaceColor,
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
                                              color: AppColors
                                                  .secondaryShadowColor,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color:
                                                AppColors.secondaryShadowColor,
                                          ),
                                        ),
                                ).withPadding(
                                  EdgeInsets.symmetric(
                                    horizontal: 0.0,
                                    vertical: 12.0,
                                  ),
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
      },
    );
  }
}
