import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class CourseProgress extends StatelessWidget {
  const CourseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.course.chapters != current.course.chapters ||
            previous.isLoadingCourse != current.isLoadingCourse ||
            previous.chapterLoadingStatus != current.chapterLoadingStatus;
      },
      builder: (context, state) {
        bool isLoading = state.chapterLoadingStatus.values.any(
          (status) => status.isGenerating,
        );
        return state.isLoadingCourse
            ? ListCard(
                child: Column(
                  children: state.course.chapters.map((chapter) {
                    final status = state.chapterLoadingStatus[chapter.id]!;
                    return ListTile(
                      leading: status.generationResultCode == 1
                          ? CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 12,
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: AppColors.secondaryColor,
                              radius: 12,
                              child: Text(
                                "${state.course.chapters.indexOf(chapter) + 1}",
                                style: AppStyles.textStyleSmallOnSurface,
                              ),
                            ),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          chapter.title,
                          style: AppStyles.textStyleSmallWeak,
                        ),
                      ),
                      trailing: status.generationResultCode == 1
                          ? SizedBox.shrink()
                          : status.generationResultCode == 0
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<GenerateCourseBloc>().add(
                                        GenerateChapter(chapter),
                                      );
                                    },
                              icon: Icon(
                                Icons.refresh,
                                color: AppColors.primaryColor,
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ).withPadding(
                EdgeInsets.symmetric(
                  horizontal: AppDimensions.pagePadding,
                  vertical: AppDimensions.pagePadding / 2,
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}
