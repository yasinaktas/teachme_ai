import 'package:teachme_ai/models/course.dart';

abstract class CourseEvent {}

class CourseFetchEvent extends CourseEvent {}

class CourseAddEvent extends CourseEvent {
  final Course course;

  CourseAddEvent(this.course);
}


