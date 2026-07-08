import 'package:dio/dio.dart';

/// Chuyển các lỗi Dio thành message tiếng Việt dễ hiểu,
/// để UI (ví dụ SnackBar, Dialog) có thể hiển thị trực tiếp
/// mà không cần tự switch-case statusCode ở từng màn hình.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = _mapErrorToMessage(err);
    handler.next(err.copyWith(error: message));
  }

  String _mapErrorToMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối đến máy chủ quá thời gian chờ.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối mạng. Vui lòng kiểm tra Internet.';
      case DioExceptionType.cancel:
        return 'Yêu cầu đã bị hủy.';
      case DioExceptionType.badResponse:
        return _mapStatusCode(err.response?.statusCode);
      default:
        return 'Đã có lỗi không xác định xảy ra.';
    }
  }

  String _mapStatusCode(int? code) {
    switch (code) {
      case 400:
        return 'Yêu cầu không hợp lệ.';
      case 401:
        return 'Phiên đăng nhập đã hết hạn.';
      case 403:
        return 'Bạn không có quyền truy cập chức năng này.';
      case 404:
        return 'Không tìm thấy dữ liệu yêu cầu.';
      case 500:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      default:
        return 'Lỗi không xác định (mã $code).';
    }
  }
}