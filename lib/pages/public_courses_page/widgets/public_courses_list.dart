import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/public_course_card.dart';

class PublicCoursesList extends StatelessWidget {
  const PublicCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state.courses.isEmpty) {
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
          return SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            sliver: SliverGrid.builder(
              itemCount: state.courses.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimensions.pagePadding,
                crossAxisSpacing: AppDimensions.pagePadding,
              ),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return PublicCourseCard(course: course);
              },
            ),
          );
        }
      },
    );
  }
}
