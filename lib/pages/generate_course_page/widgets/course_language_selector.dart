import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_languages.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_choice_chip.dart';

class CourseLanguageSelector extends StatelessWidget {
  const CourseLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.course.language != current.course.language ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          children: AppLanguages.languages.map((language) {
            final isSelected = state.course.language == language.name;
            return AppChoiceChip(
              text: language.name,
              isSelected: isSelected,
              isEnabled: !state.lockTop,
              onSelected: (selected) {
                context.read<GenerateCourseBloc>().add(
                  SelectLanguage(language.name),
                );
              },
            );
          }).toList(),
        );
      },
    ).withPadding();
  }
}
