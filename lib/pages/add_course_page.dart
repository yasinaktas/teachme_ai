import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reorderables/reorderables.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_languages.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _titleController.text = context
        .read<GenerateCourseBloc>()
        .state
        .course
        .title;
    _descriptionController = TextEditingController();
    _descriptionController.text = context
        .read<GenerateCourseBloc>()
        .state
        .course
        .description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage ||
            previous.course.description != current.course.description ||
            previous.course.title != current.course.title ||
            previous.isCourseGenerated != current.isCourseGenerated;
      },
      listener: (context, state) {
        _descriptionController.text = state.course.description;
        _titleController.text = state.course.title;
        /*if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }*/
        if (state.isCourseGenerated) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        bool isLoading = state.chapterLoadingStatus.values.any(
          (status) => status.isGenerating,
        );
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              "New Course",
              style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
            ),
            actions: [
              Visibility(
                visible: isLoading,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
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
                children: [
                  TopBanner(
                    topText: "Start learning",
                    bottomText: "In minutes",
                    imagePath: "assets/images/balik.png",
                  ),
                  Container(
                    color: AppColors.backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Language",
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ).withPadding(),
                        Wrap(
                          spacing: 8,
                          children: AppLanguages.languages.map((language) {
                            final isSelected =
                                state.course.language == language.name;
                            return ChoiceChip(
                              label: Text(
                                language.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.secondaryColor,
                                ),
                              ),
                              backgroundColor: AppColors.backgroundColor,
                              disabledColor: AppColors.backgroundColor,
                              selectedColor: AppColors.primaryColor,
                              showCheckmark: false,
                              selected: isSelected,
                              onSelected: state.lockTop
                                  ? null
                                  : (selected) {
                                      context.read<GenerateCourseBloc>().add(
                                        SelectLanguage(language.name),
                                      );
                                    },
                            );
                          }).toList(),
                        ).withPadding(),
                        Text(
                          "Title",
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ).withPadding(),
                        TextField(
                          enabled: !state.lockTop,
                          controller: _titleController,
                          onChanged: (value) {
                            context.read<GenerateCourseBloc>().add(
                              SetTitle(value),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "Enter course title",
                            hintStyle: TextStyle(
                              color: AppColors.secondaryColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.pagePadding,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.textFieldRadius,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        ).withPadding(),
                        Row(
                          children: [
                            Visibility(
                              visible: state.isLoadingChapterTitles,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurfaceColor,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.listCardRadius,
                                  ),
                                ),
                                child:
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppDimensions.pagePadding,
                                        ),
                                        Text(
                                          "Generating subtitles...",
                                          style: GoogleFonts.quicksand(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ).withPadding(
                                      EdgeInsets.symmetric(
                                        horizontal: AppDimensions.pagePadding,
                                        vertical: AppDimensions.pagePadding / 2,
                                      ),
                                    ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              height: AppDimensions.buttonHeight,
                              child: ElevatedButton(
                                onPressed: state.lockTop
                                    ? null
                                    : () async {
                                        context.read<GenerateCourseBloc>().add(
                                          GenerateChapterTitles(),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  "Next",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).withPadding(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.secondaryShadowColor,
                          thickness: 0.5,
                          indent: AppDimensions.pagePadding,
                          endIndent: AppDimensions.pagePadding,
                        ),
                      ),
                      Text(
                        "Continue",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryShadowColor,
                        ),
                      ).withPadding(
                        EdgeInsets.symmetric(
                          horizontal: AppDimensions.pagePadding / 2,
                          vertical: AppDimensions.pagePadding / 2,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.secondaryShadowColor,
                          thickness: 0.5,
                          indent: AppDimensions.pagePadding,
                          endIndent: AppDimensions.pagePadding,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: AppColors.backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Description",
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ).withPadding(),
                        TextField(
                          enabled: !state.lockBottom,
                          controller: _descriptionController,
                          onChanged: (value) {
                            context.read<GenerateCourseBloc>().add(
                              SetDescription(value),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "Course description",
                            hintStyle: TextStyle(
                              color: AppColors.secondaryColor,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.pagePadding,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.textFieldRadius,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        ).withPadding(),
                        Text(
                          "Subtitles",
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ).withPadding(),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: !state.lockBottom,
                                onChanged: (value) {
                                  context.read<GenerateCourseBloc>().add(
                                    SetSubtitle(value),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: "Add subtitle",
                                  hintStyle: TextStyle(
                                    color: AppColors.secondaryColor,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.pagePadding,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.textFieldRadius,
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: state.lockBottom
                                  ? null
                                  : () {
                                      context.read<GenerateCourseBloc>().add(
                                        AddSubtitle(),
                                      );
                                    },
                              child: Text(
                                "Add",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ).withPadding(),
                        ReorderableWrap(
                          spacing: 8,
                          runSpacing: 4,
                          onReorder: (oldIndex, newIndex) {
                            context.read<GenerateCourseBloc>().add(
                              ReorderChapters(oldIndex, newIndex),
                            );
                            /*setState(() {
                              if (oldIndex < newIndex) newIndex -= 1;
                              final item = state.course.chapters.removeAt(
                                oldIndex,
                              );
                              state.course.chapters.insert(newIndex, item);
                            });*/
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
                              labelStyle: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryColor,
                              ),
                              onDeleted: state.lockBottom
                                  ? null
                                  : () {
                                      context.read<GenerateCourseBloc>().add(
                                        RemoveSubtitle(chapter.title),
                                      );
                                    },
                            );
                          }).toList(),
                        ).withPadding(),
                        Text(
                          "Questions",
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ).withPadding(),
                        CheckboxListTile(
                          value: state.generateQuestions,
                          enabled: !state.lockBottom,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            context.read<GenerateCourseBloc>().add(
                              ToggleGenerateQuestions(),
                            );
                          },
                          title: Text(
                            "Generate questions for each chapter",
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                        if (state.isLoadingCourse)
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimensions.pagePadding / 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.listCardRadius,
                              ),
                            ),
                            child: Column(
                              children: state.course.chapters.map((chapter) {
                                final status =
                                    state.chapterLoadingStatus[chapter.id]!;
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
                                          backgroundColor:
                                              AppColors.secondaryColor,
                                          radius: 12,
                                          child: Text(
                                            "${state.course.chapters.indexOf(chapter) + 1}",
                                            style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Text(
                                      chapter.title,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryColor,
                                      ),
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
                                                  context
                                                      .read<
                                                        GenerateCourseBloc
                                                      >()
                                                      .add(
                                                        GenerateChapter(
                                                          chapter,
                                                        ),
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
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<GenerateCourseBloc>().add(
                                        Clear(),
                                      );
                                    },
                              child: Text(
                                "Clear",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: AppDimensions.buttonHeight + 8,
                                child: ElevatedButton(
                                  onPressed: state.lockBottom
                                      ? null
                                      : () {
                                          context
                                              .read<GenerateCourseBloc>()
                                              .add(GenerateCourse());
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    "Create Course",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).withPadding(
                          EdgeInsets.symmetric(
                            horizontal: AppDimensions.pagePadding,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
