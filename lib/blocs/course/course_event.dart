import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';

abstract class CourseEvent {}

class CourseFetchEvent extends CourseEvent {}

class CourseAddEvent extends CourseEvent {
  final Course course;
  CourseAddEvent(this.course);
}

class CourseUpdateEvent extends CourseEvent {
  final Course course;
  CourseUpdateEvent(this.course);
}

class ChapterUpdateEvent extends CourseEvent {
  final Chapter chapter;
  ChapterUpdateEvent(this.chapter);
}

class CourseDeleteEvent extends CourseEvent {
  final String courseId;
  CourseDeleteEvent(this.courseId);
}

class CourseSearchEvent extends CourseEvent {
  final String searchText;
  CourseSearchEvent(this.searchText);
}

class CoursesUpdatedEvent extends CourseEvent {
  final List<Course> courses;
  CoursesUpdatedEvent(this.courses);
}