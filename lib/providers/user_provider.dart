import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/core/utils/formatters.dart';
import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/data/models/app_user.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  bool get hasUser => _currentUser != null;

  void setUser(User user) {
    final AppUser appUser = AppUser(
        id: user.uid,
        fullName: user.displayName ?? '',
        username: generateUsername(user.email ?? ''),
        wallets: MockData.currentUser.wallets);
    _currentUser = appUser;

    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    notifyListeners();
  }
}
