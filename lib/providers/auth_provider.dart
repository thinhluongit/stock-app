import 'package:flutter/material.dart';
import 'package:stock_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  final AuthService _service = AuthService();

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<void> autoLogin() async {
    // TODO:
    // Đọc token từ SharedPreferences
    // Kiểm tra token
    await Future.delayed(const Duration(seconds: 3));

    _isLoggedIn = false;

    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final token = await _service.login(
      username: username,
      password: password,
    );

    // await Future.delayed(const Duration(milliseconds: 600));

    // TODO: Gọi API Login
    
    _isLoading = false;

    if (token != null) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;

    // TODO:
    // Xóa SharedPreferences

    notifyListeners();
  }
}
