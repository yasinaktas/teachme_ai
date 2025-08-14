import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
            child: Stack(
              children: [
                Center(
                  child:
                      Text(
                        "No courses found",
                        style: AppStyles.textStyleNormalLight,
                      ).withPadding(
                        EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).padding.bottom +
                              AppDimensions.pagePadding,
                        ),
                      ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child:
                      Lottie.asset(
                        "assets/lotties/arrow_blue.json",
                        width: 100,
                        height: 100,
                      ).withPadding(
                        EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).padding.bottom +
                              AppDimensions.pagePadding,
                        ),
                      ),
                ),
              ],
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
