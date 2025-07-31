import 'package:flutter/material.dart';
import 'package:teachme_ai/models/course.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/i_generate_course_repository.dart';
import 'package:teachme_ai/services/i_ai_api_service.dart';

class GenerateCourseRepository implements IGenerateCourseRepository {
  final IAiApiService _aiApiService;

  GenerateCourseRepository({required IAiApiService aiApiService})
    : _aiApiService = aiApiService;

  @override
  Future<ApiResult<Course>> generateChapterTranscripts(Course course) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Course>> generateChapters(Course course) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Course>> generateQuestions(Course course) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Course>> generateSubtitles(Course course) async {
    try{
       final response = _aiApiService.ask("");
       debugPrint(response.toString());
      // response bir json objesi olacak ve DTO'ya çevrilecek
      // Bu Json objesinde String listesi olarak alt başlıklar olacak
      // Bu Json objesinde ayrıca description da olacak
      return Success(course);
    }catch(e){
      return Failure("Subtitles cannot be produces: ${e.toString()}");
    }
  }
}
