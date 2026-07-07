import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "";
  String _account = "";

  String get userName => _userName;
  String get account => _account;

  void setUser({
    required String userName,
    required String account,
  }) {
    _userName = userName;
    _account = account;

    notifyListeners();
  }

  void clear() {
    _userName = "";
    _account = "";

    notifyListeners();
  }
}