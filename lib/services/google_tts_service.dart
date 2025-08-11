import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/services/dio_client.dart';
import 'package:teachme_ai/services/interfaces/i_tts_service.dart';

class GoogleTtsService implements ITtsService {
  final Dio _dio = DioClient().dio;

  @override
  Future<ApiResult<String>> generateSpeech(
    String ssmlText,
    String languageCode,
    String voiceName,
    String fileName,
  ) async {
    try {
      final response = await _dio.post(
        "/generateSpeech",
        data: {
          'ssml_text': ssmlText,
          'language_code': languageCode,
          'voice_name': voiceName,
        },
      );
      final base64Audio = response.data['audio_base64'];
      final bytes = base64Decode(base64Audio);
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$fileName.mp3");
      await file.writeAsBytes(bytes, flush: true);
      return Success(file.path);
    } catch (e) {
      return Failure("Failed to generate speech: ${e.toString()}");
    }
  }
}
