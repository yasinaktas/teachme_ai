import 'package:equatable/equatable.dart';
import 'package:teachme_ai/enums/course_detail_level.dart';
import 'package:teachme_ai/enums/course_knowledge_level.dart';
import 'package:teachme_ai/models/chapter_status.dart';
import 'package:teachme_ai/models/course.dart';

class GenerateCourseState extends Equatable {
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
  final CourseDetailLevel? detailLevel;
  final KnowledgeLevel? knowledgeLevel;

  const GenerateCourseState({
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
    this.detailLevel = CourseDetailLevel.detailed,
    this.knowledgeLevel = KnowledgeLevel.beginner,
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
    CourseDetailLevel? detailLevel,
    KnowledgeLevel? knowledgeLevel,
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
      detailLevel: detailLevel ?? this.detailLevel,
      knowledgeLevel: knowledgeLevel ?? this.knowledgeLevel,
    );
  }

  @override
  List<Object?> get props => [
    course,
    subtitle,
    generateQuestions,
    lockTop,
    lockBottom,
    isLoadingChapterTitles,
    isLoadingCourse,
    chapterLoadingStatus,
    isCourseGenerated,
    errorMessage,
    detailLevel,
    knowledgeLevel,
  ];
}
