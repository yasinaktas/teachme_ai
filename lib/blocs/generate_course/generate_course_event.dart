abstract class GenerateCourseEvent {}

class SelectLanguage extends GenerateCourseEvent {
  final String language;

  SelectLanguage(this.language);
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

class GenerateCourse extends GenerateCourseEvent {}

class Clear extends GenerateCourseEvent {}
