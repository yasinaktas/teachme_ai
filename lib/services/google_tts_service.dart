import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/services/dio_client.dart';
import 'package:teachme_ai/services/interfaces/i_tts_service.dart';

class GoogleTtsService implements ITtsService {
  final Dio _dio = DioClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<ApiResult<String>> generateSpeech(
    String ssmlText,
    String languageCode,
    String voiceName,
    String fileName,
  ) async {
    try {
      final token = await _storage.read(key: 'custom_jwt');
      if (token == null) throw Exception("No stored JWT");
      final response = await _dio.post(
        "/generateSpeech",
        data: {
          'ssml_text': ssmlText,
          'language_code': languageCode,
          'voice_name': voiceName,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
