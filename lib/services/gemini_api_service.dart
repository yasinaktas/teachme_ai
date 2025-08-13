import 'dart:convert';
import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/services/dio_client.dart';
import 'package:teachme_ai/services/interfaces/i_ai_api_service.dart';
import 'package:dio/dio.dart';

class GeminiApiService implements IAiApiService {
  final Dio _dio = DioClient().dio;

  @override
  Future<ApiResult<DtoSubtitles>> generateSubtitlesAndDescription(
    String title,
    String language,
  ) async {
    try {
      final response = await _dio.post(
        '/generateSubtitles',
        data: {'title': title, 'language': language},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final json = data is String ? jsonDecode(data) : data;
        return Success(DtoSubtitles.fromJson(json));
      } else {
        return Failure(
          "Cannot generate subtitles: ${response.statusMessage}",
          code: response.statusCode,
        );
      }
    } catch (e) {
      return Failure(
        "Failed to generate subtitles and description: ${e.toString()}",
      );
    }
  }

  @override
  Future<ApiResult<DtoChapterContent>> generateChapterContent(
    String title,
    String language,
    String chapterTitle,
    List<String> chapterTitles,
  ) async {
    try {
      final response = await _dio.post(
        '/generateChapterContent',
        data: {
          'title': title,
          'language': language,
          'chapter_title': chapterTitle,
          'chapter_titles': chapterTitles,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final json = data is String ? jsonDecode(data) : data;
        return Success(DtoChapterContent.fromJson(json));
      } else {
        return Failure(
          "Cannot generate chapter content: ${response.statusMessage}",
          code: response.statusCode,
        );
      }
    } catch (e) {
      return Failure("Failed to generate chapter content: ${e.toString()}");
    }
  }

  @override
  Future<ApiResult<DtoChapterTranscript>> generateChapterTranscript(
    String title,
    String language,
    String chapterTitle,
    List<String> chapterTitles,
    String content,
  ) async {
    try {
      final response = await _dio.post(
        '/generateChapterTranscript',
        data: {
          'title': title,
          'language': language,
          'chapter_title': chapterTitle,
          'chapter_titles': chapterTitles,
          'content': content,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final json = data is String ? jsonDecode(data) : data;
        return Success(DtoChapterTranscript.fromJson(json));
      } else {
        return Failure(
          "Cannot generate chapter transcript: ${response.statusMessage}",
          code: response.statusCode,
        );
      }
    } catch (e) {
      return Failure("Failed to generate chapter transcript: ${e.toString()}");
    }
  }

  @override
  Future<ApiResult<DtoChapterQuestions>> generateChapterQuestions(
    String title,
    String language,
    String chapterTitle,
    String content,
  ) async {
    try {
      final response = await _dio.post(
        '/generateChapterQuiz',
        data: {
          'language': language,
          'title': title,
          'chapter_title': chapterTitle,
          'content': content,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final json = data is String ? jsonDecode(data) : data;
        return Success(DtoChapterQuestions.fromJson(json));
      } else {
        return Failure(
          "Cannot generate chapter questions: ${response.statusMessage}",
          code: response.statusCode,
        );
      }
    } catch (e) {
      return Failure("Failed to generate chapter questions: ${e.toString()}");
    }
  }
}
