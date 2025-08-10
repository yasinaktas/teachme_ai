import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class CourseGeneratedSubtitles extends StatelessWidget {
  const CourseGeneratedSubtitles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.course.chapters != current.course.chapters ||
            previous.lockBottom != current.lockBottom;
      },
      builder: (context, state) {
        return ReorderableWrap(
          spacing: 8,
          runSpacing: 4,
          onReorder: (oldIndex, newIndex) {
            context.read<GenerateCourseBloc>().add(
              ReorderChapters(oldIndex, newIndex),
            );
          },
          children: state.course.chapters.map((chapter) {
            return Chip(
              key: ValueKey(chapter.id),
              label: Text(
                chapter.title,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              backgroundColor: AppColors.backgroundColor,
              labelStyle: AppStyles.textStyleNormalWeak,
              onDeleted: state.lockBottom
                  ? null
                  : () {
                      context.read<GenerateCourseBloc>().add(
                        RemoveSubtitle(chapter.title),
                      );
                    },
            );
          }).toList(),
        ).withPadding();
      },
    );
  }
}
