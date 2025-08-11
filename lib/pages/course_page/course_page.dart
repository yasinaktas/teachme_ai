import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/pages/course_page/widgets/chapter_card.dart';
import 'package:teachme_ai/pages/course_page/widgets/delete_course_popup.dart';
import 'package:teachme_ai/pages/course_page/widgets/course_page_course_card.dart';

class CoursePage extends StatelessWidget {
  final String courseId;
  const CoursePage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      buildWhen: (previous, current) => previous.courses != current.courses,
      builder: (context, state) {
        final course = state.courses.firstWhereOrNull((c) => c.id == courseId);
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text("Enjoy Learning", style: AppStyles.textStylePageTitle),
            actions: [
              if (course != null) DeleteCoursePopup(courseId: course.id),
            ],
          ),
          body: course == null
              ? Center(
                  child: Text(
                    "Course not found",
                    style: AppStyles.textStyleNormalLight,
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    Text(
                      "Course Summary",
                      style: AppStyles.textStyleTitleStrong,
                    ).withPadding().asSliverBox(),
                    CoursePageCourseCard(course: course).asSliverBox(),
                    Text(
                      "Chapters",
                      style: AppStyles.textStyleTitleStrong,
                    ).withPadding().asSliverBox(),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final chapter = course.chapters[index];
                        return ChapterCard(chapter: chapter, index: index);
                      }, childCount: course.chapters.length),
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(context).padding.bottom +
                          AppDimensions.pagePadding,
                    ).asSliverBox(),
                  ],
                ),
        );
      },
    );
  }
}
