import 'package:teachme_ai/models/chapter_status.dart';
import 'package:teachme_ai/models/course.dart';

class GenerateCourseState {
  final Course course;
  final String? subtitle;
  final bool generateQuestions;
  final bool lockTop;
  final bool lockBottom;
  final bool isLoadingChapterTitles;
  final bool isLoadingCourse;
  final Map<String, ChapterStatus> chapterLoadingStatus;
  final bool isCourseGenerated;
  final String? errorMessage;

  GenerateCourseState({
    required this.course,
    this.subtitle,
    this.generateQuestions = false,
    this.lockTop = false,
    this.lockBottom = true,
    this.isLoadingChapterTitles = false,
    this.isLoadingCourse = false,
    this.chapterLoadingStatus = const {},
    this.isCourseGenerated = false,
    this.errorMessage,
  });

  GenerateCourseState copyWith({
    Course? course,
    String? subtitle,
    bool? generateQuestions,
    bool? lockTop,
    bool? lockBottom,
    bool? isLoadingChapterTitles,
    bool? isLoadingCourse,
    Map<String, ChapterStatus>? chapterLoadingStatus,
    bool? isCourseGenerated,
    String? errorMessage,
  }) {
    return GenerateCourseState(
      course: course ?? this.course,
      subtitle: subtitle ?? this.subtitle,
      generateQuestions: generateQuestions ?? this.generateQuestions,
      lockTop: lockTop ?? this.lockTop,
      lockBottom: lockBottom ?? this.lockBottom,
      isLoadingChapterTitles:
          isLoadingChapterTitles ?? this.isLoadingChapterTitles,
      isLoadingCourse: isLoadingCourse ?? this.isLoadingCourse,
      chapterLoadingStatus: chapterLoadingStatus ?? this.chapterLoadingStatus,
      isCourseGenerated: isCourseGenerated ?? this.isCourseGenerated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/*class GenerateCourseState {
  final String language;
  final String title;
  final String description;
  final String subtitle;
  final List<String> chapterTitles;
  final bool generateQuestions;
  final bool lockTop;
  final bool lockBottom;
  final bool isLoadingChapterTitles;
  final bool isLoadingCourse;
  final Map<String, ChapterStatus> chapterLoadingStatus;
  final bool isCourseGenerated;
  final String? errorMessage;

  GenerateCourseState({
    required this.language,
    required this.title,
    required this.description,
    required this.chapterTitles,
    required this.subtitle,
    this.generateQuestions = false,
    this.lockTop = false,
    this.lockBottom = true,
    this.isLoadingChapterTitles = false,
    this.isLoadingCourse = false,
    this.chapterLoadingStatus = const {},
    this.isCourseGenerated = false,
    this.errorMessage,
  });

  GenerateCourseState copyWith({
    String? language,
    String? title,
    String? description,
    String? subtitle,
    List<String>? chapterTitles,
    bool? generateQuestions,
    bool? lockTop,
    bool? lockBottom,
    bool? isLoadingChapterTitles,
    bool? isLoadingCourse,
    Map<String, ChapterStatus>? chapterLoadingStatus,
    bool? isCourseGenerated,
    String? errorMessage,
  }) {
    return GenerateCourseState(
      language: language ?? this.language,
      title: title ?? this.title,
      description: description ?? this.description,
      chapterTitles: chapterTitles ?? this.chapterTitles,
      subtitle: subtitle ?? this.subtitle,
      generateQuestions: generateQuestions ?? this.generateQuestions,
      lockTop: lockTop ?? this.lockTop,
      lockBottom: lockBottom ?? this.lockBottom,
      isLoadingChapterTitles:
          isLoadingChapterTitles ?? this.isLoadingChapterTitles,
      isLoadingCourse: isLoadingCourse ?? this.isLoadingCourse,
      chapterLoadingStatus: chapterLoadingStatus ?? this.chapterLoadingStatus,
      isCourseGenerated: isCourseGenerated ?? this.isCourseGenerated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}*/
