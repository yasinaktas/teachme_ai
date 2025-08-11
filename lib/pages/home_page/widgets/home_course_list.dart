import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/pages/home_page/widgets/course_card.dart';

class HomeCourseList extends StatelessWidget {
  const HomeCourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state.filteredCourses.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child:
                  Text(
                    'No courses available',
                    style: AppStyles.textStyleNormal,
                  ).withPadding(
                    EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).padding.bottom +
                          AppDimensions.pagePadding,
                    ),
                  ),
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final course = state.filteredCourses[index];
              return CourseCard(course: course);
            }, childCount: state.filteredCourses.length),
          );
        }
      },
    );
  }
}
