import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/repositories/i_course_repository.dart';
import 'package:teachme_ai/services/i_course_service.dart';

class HiveCourseRepository implements ICourseRepository {
  final ICourseService _courseService;

  HiveCourseRepository(this._courseService);

  @override
  Future<void> addCourse(Course course) {
    return _courseService.addCourse(course);
  }

  @override
  Future<List<Course>> getCourses() {
    return _courseService.fetchCourses();
  }

  @override
  Future<void> updateChapter(Chapter chapter) {
    return _courseService.updateChapter(chapter);
  }

  @override
  Future<void> updateCourse(Course course) {
    return _courseService.updateCourse(course);
  }

  @override
  Future<void> deleteCourse(String courseId) {
    return _courseService.deleteCourse(courseId);
  }

  @override
  Stream<List<Course>> get coursesStream => _courseService.coursesStream;
}
