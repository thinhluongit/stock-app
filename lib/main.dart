import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/features/login/login_page.dart';
import 'package:stock_app/features/login/splash_page.dart';
import 'package:stock_app/firebase_options.dart';
import 'package:stock_app/providers/auth_provider.dart';
import 'package:stock_app/providers/noti_provider.dart';
import 'package:stock_app/providers/trading_provider.dart';
import 'package:stock_app/providers/user_provider.dart';
import 'package:stock_app/services/notification_service.dart';
import 'package:stock_app/services/socket_service.dart';
import 'package:stock_app/services/stock_service.dart';

import 'core/localization/app_locales.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };

  await NotificationService.instance.init();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback,
      child: MultiProvider(
        providers: [
          Provider<SocketService>(
            lazy: false,
            create: (_) {
              final service = SocketService();
              service.connect();
              return service;
            },
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (_) {
              debugPrint(">>>> AuthProvider CREATED");
              return AuthProvider();
            },
          ),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<TradingProvider>(
            create: (_) => TradingProvider(),
          ),
          ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider(),
          ),
          Provider<StockService>(
            create: (context) => StockService(
              context.read<SocketService>(),
            ),
          )
        ],
        child: const StockApp(),
      ),
    ),
  );
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    debugPrint(auth.toString());
    return MaterialApp(
      title: 'appName'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // easy_localization wiring
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashPage(),

      routes: {
        '/login': (_) => const LoginPage(),
        // '/home': (_) => HomePage(user: MockData.currentUser),
      },
    );
  }
}
