import 'package:dio/dio.dart';
import 'package:stock_app/services/token_storage_service.dart';

/// Dùng QueuedInterceptor để đảm bảo khi nhiều request cùng bị 401
/// cùng lúc thì chỉ gọi API refresh-token MỘT lần duy nhất,
/// các request khác sẽ được xếp hàng chờ rồi tự động gửi lại.
class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({
    required Dio dio,
    required Dio refreshDio,
  })  : _dio = dio,
        _refreshDio = refreshDio;

  /// Dio chính, dùng để gửi lại (retry) request ban đầu sau khi có token mới.
  final Dio _dio;

  /// Dio "sạch" (không gắn interceptor), chỉ dùng để gọi API refresh-token,
  /// tránh vòng lặp vô hạn nếu chính request refresh cũng trả về lỗi.
  final Dio _refreshDio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Chỉ xử lý khi lỗi là 401 (access token hết hạn)
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final refreshToken = await TokenStorageService.instance.getRefreshToken();
      if (refreshToken == null) {
        await TokenStorageService.instance.clear();
        return handler.next(err);
      }

      // Gọi API lấy access token mới
      final response = await _refreshDio.post(
        '/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String?;

      await TokenStorageService.instance.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Gắn token mới vào request cũ rồi gửi lại
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(err.requestOptions);

      return handler.resolve(retryResponse);
    } catch (e) {
      // Refresh token cũng hết hạn hoặc lỗi -> đăng xuất người dùng
      await TokenStorageService.instance.clear();
      return handler.next(err);
    }
  }
}