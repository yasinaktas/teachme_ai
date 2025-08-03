import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/repositories/api_result.dart';

abstract interface class IGenerateCourseRepository {
  Future<ApiResult<DtoSubtitles>> getGeneratedSubtitles(
    String title,
    String language,
    int count,
  );

  Future<ApiResult<DtoChapterContent>> getGeneratedChapterContent(
    String title,
    String language,
    String chapterTitle,
    int length,
  );

  Future<ApiResult<DtoChapterTranscript>> getGeneratedChapterTranscript(
    String title,
    String language,
    String chapterTitle,
    String content,
  );

  Future<ApiResult<DtoChapterQuestions>> generateChapterQuestions(
    String title,
    String language,
    String chapterTitle,
    String content,
  );
}
