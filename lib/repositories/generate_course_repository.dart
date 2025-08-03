import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/i_generate_course_repository.dart';
import 'package:teachme_ai/services/i_ai_api_service.dart';

class GenerateCourseRepository implements IGenerateCourseRepository {
  final IAiApiService _aiApiService;

  GenerateCourseRepository({required IAiApiService aiApiService})
    : _aiApiService = aiApiService;

  @override
  Future<ApiResult<DtoSubtitles>> getGeneratedSubtitles(
    String title,
    String language,
    int count,
  ) async {
    return await _aiApiService.generateSubtitlesAndDescription(
      title,
      language,
      count,
    );
  }

  @override
  Future<ApiResult<DtoChapterContent>> getGeneratedChapterContent(String title, String language, String chapterTitle, int length) async{
    return await _aiApiService.generateChapterContent(
      title,
      language,
      chapterTitle,
      length,
    );
  }

  @override
  Future<ApiResult<DtoChapterTranscript>> getGeneratedChapterTranscript(String title, String language, String chapterTitle, String content) async{
    return await _aiApiService.generateChapterTranscript(
      title,
      language,
      chapterTitle,
      content
    );
  }

  @override
  Future<ApiResult<DtoChapterQuestions>> generateChapterQuestions(String title, String language, String chapterTitle, String content) async{
    return await _aiApiService.generateChapterQuestions(
      title,
      language,
      chapterTitle,
      content,
    );
  }
}
