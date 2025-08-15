import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class CourseAboutInput extends StatefulWidget {
  final TextEditingController controller;
  const CourseAboutInput({super.key, required this.controller});

  @override
  State<CourseAboutInput> createState() => _CourseAboutInputState();
}

class _CourseAboutInputState extends State<CourseAboutInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = context.read<GenerateCourseBloc>().state.about;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.about != current.about;
      },
      listener: (context, state) {
        final selection = widget.controller.selection;
        widget.controller.value = TextEditingValue(
          text: state.about,
          selection: selection,
        );
      },
      buildWhen: (previous, current) {
        return previous.about != current.about ||
            previous.lockTop != current.lockTop;
      },
      builder: (context, state) {
        return AppTextField(
          controller: widget.controller,
          isEnabled: !state.lockTop,
          isMultiline: true,
          hintText: "Describe what you want to learn.",
          hint: RichText(
            text: TextSpan(
              text: "Describe what you want to learn.\n",
              style: AppStyles.textStyleNormalPrimaryDark,
              children: [
                TextSpan(
                  text:
                      "\"I want to understand AI and how machine learning works so I can build a chatbot for my website\"",
                  style: AppStyles.textStyleNormalLight,
                ),
              ],
            ),
          ),
          onChanged: (value) {
            context.read<GenerateCourseBloc>().add(SetAbout(value));
          },
        );
      },
    ).withPadding();
  }
}
