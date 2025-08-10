import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class CourseGenerateQuestionsToggle extends StatelessWidget {
  const CourseGenerateQuestionsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.generateQuestions != current.generateQuestions ||
            previous.lockBottom != current.lockBottom;
      },
      builder: (context, state) {
        return CheckboxListTile(
          value: state.generateQuestions,
          enabled: !state.lockBottom,
          activeColor: AppColors.primaryColor,
          onChanged: (value) {
            context.read<GenerateCourseBloc>().add(ToggleGenerateQuestions());
          },
          title: Text(
            "Generate questions for each chapter",
            style: AppStyles.textStyleNormalLight,
          ),
        );
      },
    );
  }
}
