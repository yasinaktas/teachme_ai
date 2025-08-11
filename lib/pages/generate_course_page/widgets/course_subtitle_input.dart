import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class CourseSubtitleInput extends StatefulWidget {
  final TextEditingController controller;
  const CourseSubtitleInput({super.key, required this.controller});

  @override
  State<CourseSubtitleInput> createState() => _CourseSubtitleInputState();
}

class _CourseSubtitleInputState extends State<CourseSubtitleInput> {

  @override
  void initState() {
    super.initState();
    widget.controller.text = context
        .read<GenerateCourseBloc>()
        .state
        .subtitle ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.subtitle != current.subtitle;
      },
      listener: (context, state) {
        final selection = widget.controller.selection;
        widget.controller.value = TextEditingValue(
          text: state.subtitle ?? '',
          selection: selection,
        );
      },
      buildWhen: (previous, current) {
        return previous.lockBottom != current.lockBottom ||
            previous.subtitle != current.subtitle;
      },
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AppTextField(
                hintText: "Add subtitle",
                controller: widget.controller,
                isEnabled: !state.lockBottom,
                onChanged: (value) {
                  context.read<GenerateCourseBloc>().add(SetSubtitle(value));
                },
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: state.lockBottom
                  ? null
                  : () {
                      context.read<GenerateCourseBloc>().add(AddSubtitle());
                    },
              child: Text("Add", style: AppStyles.textStyleLargePrimary),
            ),
          ],
        ).withPadding();
      },
    );
  }
}
