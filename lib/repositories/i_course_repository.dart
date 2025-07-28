import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';

abstract interface class ICourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourseById(String courseId);
  Future<void> addCourse(Course course);
  Future<void> updateCourse(Course course);
  Future<void> deleteCourse(String courseId);
  Future<List<Chapter>> getChaptersByCourseId(String courseId);
  Future<void> addChapter(Chapter chapter);
  Future<void> updateChapter(Chapter chapter);
  Future<void> deleteChapter(String chapterId);
}