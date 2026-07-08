import 'package:dio/dio.dart';
import 'package:stock_app/services/token_storage_service.dart';

/// Tự động gắn `Authorization: Bearer <token>` vào mọi request,
/// trừ các endpoint public như login / refresh-token.
class AuthInterceptor extends Interceptor {
  // Các path không cần gắn token
  static const _publicPaths = ['/login', '/refresh-token'];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((p) => options.path.contains(p));

    if (!isPublic) {
      final token = await TokenStorageService.instance.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}