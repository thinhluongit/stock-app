import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_app/core/localization/app_locales.dart';
import 'package:stock_app/features/menu/menu_page.dart';
import 'package:stock_app/main.dart';

Widget _wrap() => EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback,
      child: const StockApp(),
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Open menu → localized rows re-translate → logout returns to login',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Login (Vietnamese default) then open the menu from the AppBar.
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Menu rows show in Vietnamese.
    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.text('Giao dịch Tiền'), findsOneWidget);
    expect(find.text('Bảo mật'), findsOneWidget);

    // Switch language on the menu → rows re-translate in place.
    await tester.element(find.byType(MenuPage)).setLocale(const Locale('en'));
    await tester.pumpAndSettle();
    expect(find.text('Cash Transaction'), findsOneWidget);
    expect(find.text('Giao dịch Tiền'), findsNothing);

    // Logout: confirm dialog → back to the login screen.
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(MenuPage), findsNothing);
    expect(find.text('Sign in'), findsOneWidget); // login screen, now in English
  });
}
