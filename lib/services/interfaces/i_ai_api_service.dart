import 'package:teachme_ai/dto/dto_chapter_content.dart';
import 'package:teachme_ai/dto/dto_chapter_questions.dart';
import 'package:teachme_ai/dto/dto_chapter_transcript.dart';
import 'package:teachme_ai/dto/dto_subtitles.dart';
import 'package:teachme_ai/repositories/api_result.dart';

abstract interface class IAiApiService {
  Future<ApiResult<DtoSubtitles>> generateSubtitlesAndDescription(
    String about,
    String language,
    String detailLevel,
    String knowledgeLevel,
  );

  Future<ApiResult<DtoChapterContent>> generateChapterContent(
    String title,
    String language,
    String chapterTitle,
    List<String> chapterTitles,
    String detailLevel,
    String knowledgeLevel,
  );

  Future<ApiResult<DtoChapterTranscript>> generateChapterTranscript(
    String title,
    String language,
    String chapterTitle,
    List<String> chapterTitles,
    String content,
  );

  Future<ApiResult<DtoChapterQuestions>> generateChapterQuestions(
    String title,
    String language,
    String chapterTitle,
    String content,
  );
}
