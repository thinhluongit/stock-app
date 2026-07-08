import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/features/login/login_page.dart';
import 'package:stock_app/features/login/splash_page.dart';
import 'package:stock_app/providers/auth_provider.dart';

import 'core/localization/app_locales.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) {
              debugPrint(">>>> AuthProvider CREATED");
              return AuthProvider();
            },
          ),
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
