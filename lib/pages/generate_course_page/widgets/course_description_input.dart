import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class CourseDescriptionInput extends StatefulWidget {
  final TextEditingController controller;
  const CourseDescriptionInput({super.key, required this.controller});

  @override
  State<CourseDescriptionInput> createState() => _CourseDescriptionInputState();
}

class _CourseDescriptionInputState extends State<CourseDescriptionInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = context
        .read<GenerateCourseBloc>()
        .state
        .course
        .description;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.course.description != current.course.description;
      },
      listener: (context, state) {
        final selection = widget.controller.selection;
        widget.controller.value = TextEditingValue(
          text: state.course.description,
          selection: selection,
        );
      },
      buildWhen: (previous, current) {
        return previous.course.description != current.course.description ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        return AppTextField(
          controller: widget.controller,
          isEnabled: !state.lockBottom,
          hintText: "Course description",
          onChanged: (value) {
            context.read<GenerateCourseBloc>().add(SetDescription(value));
          },
        ).withPadding();
      },
    );
  }
}
