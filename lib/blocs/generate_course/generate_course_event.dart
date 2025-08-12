import 'package:teachme_ai/enums/course_detail_level.dart';
import 'package:teachme_ai/models/chapter.dart';

abstract class GenerateCourseEvent {}

class SelectLanguage extends GenerateCourseEvent {
  final String language;

  SelectLanguage(this.language);
}

class SelectDetailLevel extends GenerateCourseEvent {
  final CourseDetailLevel detailLevel;

  SelectDetailLevel(this.detailLevel);
}

class SetTitle extends GenerateCourseEvent {
  final String title;

  SetTitle(this.title);
}

class SetDescription extends GenerateCourseEvent {
  final String description;

  SetDescription(this.description);
}

class SetChapterTitles extends GenerateCourseEvent {
  final List<String> chapterTitles;

  SetChapterTitles(this.chapterTitles);
}

class SetSubtitle extends GenerateCourseEvent {
  final String subtitle;

  SetSubtitle(this.subtitle);
}

class ToggleGenerateQuestions extends GenerateCourseEvent {}

class ToggleLockTop extends GenerateCourseEvent {
  final bool lockTop;

  ToggleLockTop(this.lockTop);
}

class ToggleLockBottom extends GenerateCourseEvent {
  final bool lockBottom;

  ToggleLockBottom(this.lockBottom);
}

class AddSubtitle extends GenerateCourseEvent {}

class RemoveSubtitle extends GenerateCourseEvent {
  final String subtitle;

  RemoveSubtitle(this.subtitle);
}

class GenerateChapterTitles extends GenerateCourseEvent {}

class GenerateChapterContent extends GenerateCourseEvent {
  final Chapter chapter;
  final String title;
  final String language;
  final List<String> subtitles;

  GenerateChapterContent(
    this.chapter,
    this.title,
    this.language,
    this.subtitles,
  );
}

class GenerateChapterTranscript extends GenerateCourseEvent {
  final Chapter chapter;
  final String title;
  final String language;
  final List<String> subtitles;
  final String content;

  GenerateChapterTranscript(
    this.chapter,
    this.title,
    this.language,
    this.subtitles,
    this.content,
  );
}

class GenerateChapterQuestions extends GenerateCourseEvent {
  final Chapter chapter;
  final String title;
  final String language;
  final String content;

  GenerateChapterQuestions(
    this.chapter,
    this.title,
    this.language,
    this.content,
  );
}

class GenerateChapterAudio extends GenerateCourseEvent {
  final Chapter chapter;
  final String transcript;

  GenerateChapterAudio(this.chapter, this.transcript);
}

class GenerateChapter extends GenerateCourseEvent {
  final Chapter chapter;

  GenerateChapter(this.chapter);
}

class GenerateCourse extends GenerateCourseEvent {}

class Clear extends GenerateCourseEvent {}

class ReorderChapters extends GenerateCourseEvent {
  int oldIndex;
  int newIndex;

  ReorderChapters(this.oldIndex, this.newIndex);
}
