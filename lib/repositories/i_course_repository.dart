import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';

abstract interface class ICourseRepository {
  Stream<List<Course>> get coursesStream;
  Future<List<Course>> getCourses();
  Future<void> addCourse(Course course);
  Future<void> updateCourse(Course course);
  Future<void> updateChapter(Chapter chapter);
  Future<void> deleteCourse(String courseId);
}