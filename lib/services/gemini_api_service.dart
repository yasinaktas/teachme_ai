import 'package:teachme_ai/services/i_ai_api_service.dart';
import 'package:dio/dio.dart';

class GeminiApiService implements IAiApiService{

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  @override
  Future<String> ask(String prompt) async {
    try {
      final response = await _dio.post('/ask', data: {
        'prompt': prompt,
      });

      if (response.statusCode == 200) {
        return response.data['response'] ?? 'Boş cevap';
      } else {
        return 'Hata: ${response.statusCode}';
      }
    } catch (e) {
      return 'Hata oluştu: $e';
    }
  }

}