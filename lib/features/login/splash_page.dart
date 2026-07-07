import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_colors.dart';
import 'package:stock_app/data/mock/mock_data.dart';

import '../home/home_page.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Giả lập thời gian khởi tạo ứng dụng
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // TODO:
    // Đọc token từ SharedPreferences
    // Kiểm tra token
    // Refresh token nếu cần
    // ...

    final bool isLoggedIn = false;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => isLoggedIn
            ? HomePage(user: MockData.currentUser)
            : const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.candlestick_chart,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: 20),
            Text(
              'appName'.tr(),
              style: TextStyle(
                fontSize: 28,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
