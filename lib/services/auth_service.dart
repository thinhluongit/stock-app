import 'package:firebase_auth/firebase_auth.dart';

/// Exception dùng riêng cho tầng AuthService, tách biệt khỏi FirebaseAuthException
/// để Provider/UI không cần phụ thuộc trực tiếp vào Firebase.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Domain giả dùng để convert số điện thoại thành email nội bộ cho Firebase Auth.
  // Firebase không hỗ trợ Phone+Password trực tiếp (Phone Auth mặc định dùng OTP),
  // nên ta "mượn" cơ chế Email+Password, người dùng chỉ thấy giao diện nhập SĐT.
  static const _fakeEmailDomain = 'stockapp.local';

  String _phoneToEmail(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return '$cleanPhone@$_fakeEmailDomain';
  }

  /// Trả về idToken (dùng làm "token" lưu phía client để check autoLogin).
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final email = _phoneToEmail(username);
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw AuthException('Đăng nhập thất bại, vui lòng thử lại');
      }

      final idToken = await user.getIdToken();
      return idToken ?? '';
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapErrorCode(e.code));
    }
  }

  Future<String> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    try {
      final email = _phoneToEmail(username);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw AuthException('Đăng ký thất bại, vui lòng thử lại');
      }

      await user.updateDisplayName(fullName);
      // reload để displayName có hiệu lực ngay trên currentUser
      await user.reload();

      final idToken = await user.getIdToken();
      return idToken ?? '';
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapErrorCode(e.code));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _mapErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Số điện thoại hoặc mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Số điện thoại này đã được đăng ký';
      case 'weak-password':
        return 'Mật khẩu quá yếu, cần tối thiểu 6 ký tự';
      case 'invalid-email':
        return 'Số điện thoại không hợp lệ';
      case 'too-many-requests':
        return 'Bạn thao tác quá nhiều lần, vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng, vui lòng kiểm tra lại';
      default:
        return 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }
}