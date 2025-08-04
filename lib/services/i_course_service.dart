import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';

abstract interface class ICourseService {
  Future<List<Course>> fetchCourses();

  Future<void> addCourse(Course course);

  Future<void> updateCourse(Course course);

  Future<void> updateChapter(Chapter chapter);

  Future<void> deleteCourse(String courseId);
}