import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_about_input.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_bottom_buttons.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_description_input.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_detail_level_selector.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_generate_questions_toggle.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_generated_subtitles.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_knowledge_level_selector.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_next.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_progress.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_subtitle_input.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_title_input.dart';
import 'package:teachme_ai/widgets/circular_progress.dart';
import 'package:teachme_ai/widgets/divider_with_text.dart';
import 'package:teachme_ai/pages/generate_course_page/widgets/course_language_selector.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late TextEditingController _aboutController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _subtitleController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _subtitleController = TextEditingController();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.isCourseGenerated != current.isCourseGenerated;
      },
      listener: (context, state) {
        if (state.isCourseGenerated) {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text("New Course", style: AppStyles.textStylePageTitle),
            actions: [
              BlocBuilder<GenerateCourseBloc, GenerateCourseState>(
                buildWhen: (previous, current) {
                  return previous.chapterLoadingStatus !=
                          current.chapterLoadingStatus ||
                      previous.isLoadingChapterTitles !=
                          current.isLoadingChapterTitles;
                },
                builder: (context, state) {
                  bool isLoadingChapters = state.chapterLoadingStatus.values
                      .any((status) => status.isGenerating);
                  return Visibility(
                    visible: isLoadingChapters || state.isLoadingChapterTitles,
                    child: CircularProgress(),
                  );
                },
              ),
              SizedBox(width: AppDimensions.pagePadding),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopBanner(
                    topText: "Start learning",
                    bottomText: "In minutes",
                    imagePath: "assets/images/balik.png",
                  ),
                  /*Text(
                    "Title",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  CourseTitleInput(controller: _titleController),*/
                  Text(
                    "What to learn",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  CourseAboutInput(controller: _aboutController),
                  Text(
                    "Language",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  const CourseLanguageSelector(),
                  Text(
                    "Detail Level",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  const CourseDetailLevelSelector().withPadding(),
                  Text(
                    "Your knowledge",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  const CourseKnowledgeLevelSelector().withPadding(),
                  const CourseNext(),
                  const SizedBox(height: 16),
                  const DividerWithText(title: "Continue"),
                  Text(
                    "Title",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  CourseTitleInput(controller: _titleController),
                  Text(
                    "Description",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  CourseDescriptionInput(controller: _descriptionController),
                  Text(
                    "Subtitles",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  CourseSubtitleInput(controller: _subtitleController),
                  const CourseGeneratedSubtitles(),
                  Text(
                    "Questions",
                    style: AppStyles.textStyleTitleStrong,
                  ).withPadding(),
                  const CourseGenerateQuestionsToggle(),
                  const CourseProgress(),
                  const SizedBox(height: 16),
                  const CourseBottomButtons(),
                  const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
