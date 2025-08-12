import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/enums/course_detail_level.dart';
import 'package:teachme_ai/widgets/app_choice_chip.dart';

class CourseDetailLevelSelector extends StatelessWidget {
  const CourseDetailLevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.detailLevel != current.detailLevel ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        final selectedDetailLevel =
            state.detailLevel ?? CourseDetailLevel.detailed;
        return Wrap(
          spacing: 8.0,
          children: CourseDetailLevel.values.map((detailLevel) {
            return AppChoiceChip(
              text: detailLevel.label,
              isSelected: selectedDetailLevel == detailLevel,
              isEnabled: !state.lockTop,
              onSelected: (value) {
                context.read<GenerateCourseBloc>().add(
                  SelectDetailLevel(detailLevel),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
