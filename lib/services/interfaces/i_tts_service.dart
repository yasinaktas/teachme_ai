import 'package:teachme_ai/repositories/api_result.dart';

abstract interface class ITtsService {
  Future<ApiResult<String>> generateSpeech(
    String ssmlText,
    String languageCode,
    String voiceName,
    String fileName,
  );
}
