import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_app/api/interceptors/auth_interceptor.dart';
import 'package:stock_app/api/interceptors/error_interceptor.dart';
import 'package:stock_app/api/interceptors/token_interceptor.dart';

class ApiClient {
  static const String _baseUrl = "https://your-api.com/api";

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    // Dio "sạch" không gắn interceptor, chỉ dùng riêng cho việc gọi
    // API refresh-token, tránh vòng lặp vô hạn nếu bản thân request
    // refresh cũng bị trả về lỗi 401.
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    dio.interceptors.addAll([
      // 1. Gắn access token vào request trước khi gửi đi
      AuthInterceptor(),

      // 2. Bắt lỗi 401 -> tự động refresh token -> gửi lại request cũ
      TokenInterceptor(dio: dio, refreshDio: refreshDio),

      // 3. Map lỗi HTTP sang message tiếng Việt dễ hiểu cho UI
      ErrorInterceptor(),

      // 4. Log request/response, chỉ bật ở môi trường debug
      if (kDebugMode)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}