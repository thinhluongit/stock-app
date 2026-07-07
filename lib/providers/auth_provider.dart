import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;

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

    await Future.delayed(const Duration(milliseconds: 600));

    // TODO: Gọi API Login

    _token = "mock_token";
    _isLoggedIn = true;

    _isLoading = false;
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;

    // TODO:
    // Xóa SharedPreferences

    notifyListeners();
  }
}