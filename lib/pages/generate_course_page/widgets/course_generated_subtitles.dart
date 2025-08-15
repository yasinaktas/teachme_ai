import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
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
            return Container(
              key: ValueKey(chapter.id),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(
                  color: AppColors.secondaryShadowColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      chapter.title,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textStyleNormalWeak,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!state.lockBottom)
                    InkWell(
                      onTap: () {
                        context.read<GenerateCourseBloc>().add(
                          RemoveSubtitle(chapter.title),
                        );
                      },
                      child: Icon(
                        Icons.cancel,
                        size: AppDimensions.iconSizeSmall,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ).withPadding();

        /*ReorderableWrap(
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
        ).withPadding();*/
      },
    );
  }
}
