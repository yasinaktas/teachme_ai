import 'package:hive/hive.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/services/i_course_service.dart';

class HiveCourseService implements ICourseService {
  final _coursesBox = Hive.box<Course>("courses");

  @override
  Stream<List<Course>> get coursesStream {
    return _coursesBox.watch().asyncMap((event) {
      return fetchCourses();
    });
  }

  @override
  Future<void> addCourse(Course course) async {
    await _coursesBox.put(course.id, course);
  }

  @override
  Future<List<Course>> fetchCourses() async {
    List<Course> courses = _coursesBox.values.toList();
    courses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return courses;
  }

  @override
  Future<void> updateChapter(Chapter chapter) async {
    final course = _coursesBox.get(chapter.courseId);
    if (course != null) {
      final updatedChapters = List<Chapter>.from(course.chapters);
      final index = updatedChapters.indexWhere((c) => c.id == chapter.id);
      if (index != -1) {
        updatedChapters[index] = chapter;
        final updatedCourse = course.copyWith(chapters: updatedChapters);
        return _coursesBox.put(course.id, updatedCourse);
      }
    }
    throw Exception("Course or Chapter not found");
  }

  @override
  Future<void> updateCourse(Course course) async {
    return _coursesBox.put(course.id, course);
  }

  @override
  Future<void> deleteCourse(String courseId) {
    return _coursesBox.delete(courseId);
  }
}
