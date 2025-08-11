import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/loading_bar.dart';

class HomeGeneratingCourse extends StatelessWidget {
  const HomeGeneratingCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      builder: (context, state) {
        final isLoading = state.chapterLoadingStatus.values.any(
          (status) => status.isGenerating,
        );
        return Visibility(
          visible: isLoading,
          child: LoadingBar(title: "Generating course...").withPadding(),
        );
      },
    );
  }
}
