import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  String? _lastError;

  final AuthService _service = AuthService();

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get lastError => _lastError;

  /// Kiểm tra token đã lưu + phiên đăng nhập Firebase hiện tại (nếu còn hiệu lực)
  /// để tự động đăng nhập khi mở lại app.
  Future<void> autoLogin() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    final currentUser = _service.currentUser;

    if (savedToken != null && currentUser != null) {
      _token = savedToken;
      _isLoggedIn = true;
    } else {
      // Token cũ hoặc phiên Firebase không còn hợp lệ -> yêu cầu đăng nhập lại
      await prefs.remove(_tokenKey);
      _token = null;
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final token = await _service.login(
        username: username,
        password: password,
      );

      await _saveToken(token);

      _token = token;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _lastError = e.message;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = 'Đã có lỗi xảy ra, vui lòng thử lại';
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final token = await _service.register(
        username: username,
        password: password,
        fullName: fullName,
      );

      await _saveToken(token);

      _token = token;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _lastError = e.message;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = 'Đã có lỗi xảy ra, vui lòng thử lại';
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);

    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}