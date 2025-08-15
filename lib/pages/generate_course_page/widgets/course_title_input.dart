import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class CourseTitleInput extends StatefulWidget {
  final TextEditingController controller;
  const CourseTitleInput({super.key, required this.controller});

  @override
  State<CourseTitleInput> createState() => _CourseTitleInputState();
}

class _CourseTitleInputState extends State<CourseTitleInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = context
        .read<GenerateCourseBloc>()
        .state
        .course
        .title;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.course.title != current.course.title;
      },
      listener: (context, state) {
        final selection = widget.controller.selection;
        widget.controller.value = TextEditingValue(
          text: state.course.title,
          selection: selection,
        );
      },
      buildWhen: (previous, current) {
        return previous.course.title != current.course.title ||
            previous.lockBottom != current.lockBottom;
      },
      builder: (context, state) {
        return AppTextField(
          controller: widget.controller,
          isEnabled: !state.lockBottom,
          hintText: "Course title",
          isMultiline: true,
          onChanged: (value) {
            context.read<GenerateCourseBloc>().add(SetTitle(value));
          },
        );
      },
    ).withPadding();
  }
}
