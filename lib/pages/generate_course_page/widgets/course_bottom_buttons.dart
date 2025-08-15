import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';

class CourseBottomButtons extends StatelessWidget {
  const CourseBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.lockBottom != current.lockBottom;
      },
      builder: (context, state) {
        return AppElevatedButton(
          isActive: !state.lockBottom,
          text: "Create Course",
          onPressed: () {
            context.read<GenerateCourseBloc>().add(GenerateCourse());
          },
        ).asExpanded().withPadding(
          const EdgeInsets.symmetric(horizontal: AppDimensions.pagePadding),
        );
      },
    );
  }
}
