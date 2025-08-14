import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/enums/course_knowledge_level.dart';
import 'package:teachme_ai/widgets/app_choice_chip.dart';

class CourseKnowledgeLevelSelector extends StatelessWidget {
  const CourseKnowledgeLevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.knowledgeLevel != current.knowledgeLevel ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        final selectedKnowledgeLevel =
            state.knowledgeLevel;
        return Wrap(
          spacing: 8.0,
          children: KnowledgeLevel.values.map((knowledgeLevel) {
            return AppChoiceChip(
              text: knowledgeLevel.label,
              isSelected: selectedKnowledgeLevel == knowledgeLevel,
              isEnabled: !state.lockTop,
              onSelected: (value) {
                context.read<GenerateCourseBloc>().add(
                  SelectKnowledgeLevel(knowledgeLevel),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
