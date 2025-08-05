import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        //baseUrl: "http://192.168.1.3:8001",
        baseUrl: "https://teachmeai-8f494e051a11.herokuapp.com",
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
