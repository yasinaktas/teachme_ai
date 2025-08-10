import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';
import 'package:teachme_ai/widgets/loading_bar.dart';

class CourseNext extends StatelessWidget {
  const CourseNext({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
      buildWhen: (previous, current) {
        return previous.isLoadingChapterTitles != current.isLoadingChapterTitles ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        return Row(
          children: [
            Visibility(
              visible: state.isLoadingChapterTitles,
              child: LoadingBar(title: "Generating subtitles..."),
            ),
            const Spacer(),
            AppElevatedButton(
              isActive: !state.lockTop,
              text: "Next",
              onPressed: () async {
                context.read<GenerateCourseBloc>().add(GenerateChapterTitles());
              },
            ),
          ],
        ).withPadding();
      },
    );
  }
}
