import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/interfaces/i_tts_repository.dart';
import 'package:teachme_ai/services/interfaces/i_tts_service.dart';

class GoogleTtsRepository implements ITtsRepository{
  final ITtsService _ttsService;

  GoogleTtsRepository(this._ttsService);

  @override
  Future<ApiResult<String>> generateSpeech(String ssmlText, String languageCode, String voiceName, String fileName) async {
    return await _ttsService.generateSpeech(
      ssmlText = ssmlText,
      languageCode = languageCode,
      voiceName = voiceName,
      fileName = fileName,
    );
  }
}