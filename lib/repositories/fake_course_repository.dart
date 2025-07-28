import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/repositories/i_course_repository.dart';
import 'package:teachme_ai/services/i_course_service.dart';

class FakeCourseRepository implements ICourseRepository {
  late final ICourseService courseService;

  FakeCourseRepository({required this.courseService});

  @override
  Future<void> addChapter(Chapter chapter) {
    throw UnimplementedError();
  }

  @override
  Future<void> addCourse(Course course) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChapter(String chapterId) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCourse(String courseId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Chapter>> getChaptersByCourseId(String courseId) {
    throw UnimplementedError();
  }

  @override
  Future<Course> getCourseById(String courseId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Course>> getCourses(){
    return courseService.fetchCourses();
  }

  @override
  Future<void> updateChapter(Chapter chapter) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateCourse(Course course) {
    throw UnimplementedError();
  }
}
