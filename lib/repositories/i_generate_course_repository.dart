import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/repositories/api_result.dart';

abstract interface class IGenerateCourseRepository {
  Future<ApiResult<Course>> generateSubtitles(Course course);
  Future<ApiResult<Course>> generateChapters(Course course);
  Future<ApiResult<Course>> generateChapterTranscripts(Course course);
  Future<ApiResult<Course>> generateQuestions(Course course);
}