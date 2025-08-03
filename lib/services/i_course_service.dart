import 'package:teachme_ai/models/course.dart';

abstract interface class ICourseService {
  Future<List<Course>> fetchCourses();

  Future<void> addCourse(Course course);
}