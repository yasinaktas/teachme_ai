import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/repositories/i_course_repository.dart';
import 'package:teachme_ai/services/i_course_service.dart';

class FakeCourseRepository implements ICourseRepository {
  late final ICourseService courseService;

  FakeCourseRepository({required this.courseService});

  @override
  Future<void> addCourse(Course course) async {
    await courseService.addCourse(course);
  }

  @override
  Future<List<Course>> getCourses() {
    return courseService.fetchCourses();
  }

  @override
  Future<void> updateChapter(Chapter chapter) {
    return courseService.updateChapter(chapter);
  }

  @override
  Future<void> updateCourse(Course course) {
    return courseService.updateCourse(course);
  }

  @override
  Future<void> deleteCourse(String courseId) {
    return courseService.deleteCourse(courseId);
  }

  @override
  Stream<List<Course>> get coursesStream => courseService.coursesStream;
  
  @override
  Future<Course> getCourse(String courseId)async {
    return courseService.getCourseById(courseId);
  }
}
