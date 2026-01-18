import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  // Localhost for Android Emulator is 10.0.2.2, for iOS Simulator is 127.0.0.1 (localhost)
  // Since the user is on Mac and likely using iOS Simulator or Chrome, localhost:8080 is fine.
  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    // Add interceptors for logging
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
}
