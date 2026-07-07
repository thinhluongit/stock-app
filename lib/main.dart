import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/features/login/splash_page.dart';

import 'core/localization/app_locales.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback, // Vietnamese by default
      child: const StockApp(),
    ),
  );
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'appName'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // easy_localization wiring
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashPage(),
    );
  }
}
