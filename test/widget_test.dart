import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_app/core/localization/app_locales.dart';
import 'package:stock_app/core/localization/language_switcher.dart';
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

  // easy_localization keeps static state; keep a single lifecycle per test file.
  testWidgets(
      'Login → home; changing language re-translates content AND keeps the sub-tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Vietnamese by default.
    expect(find.text('Đăng nhập'), findsOneWidget);
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();

    // On the Market tab, default sub-tab = Overview (shows "Chỉ số thị trường").
    expect(find.text('Thị Trường'), findsWidgets);
    expect(find.text('Chỉ số thị trường'), findsOneWidget);

    // Move to the 2nd sub-tab "Cổ phiếu" (index 1) of the Market tab.
    final marketTabBar = find.byType(TabBar).first;
    await tester.tap(
      find.descendant(of: marketTabBar, matching: find.text('Cổ phiếu')),
    );
    await tester.pumpAndSettle();

    TabController controllerOf() =>
        DefaultTabController.of(tester.element(marketTabBar));
    expect(controllerOf().index, 1); // now on "Cổ phiếu"
    expect(find.text('Chỉ số thị trường'), findsNothing); // left Overview

    // Switch language to English via the AppBar switcher.
    await tester.tap(find.byType(LanguageSwitcher).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    // 1) Content re-translated IN PLACE (Vietnamese header gone, English present).
    expect(find.text('Mã CK'), findsNothing);
    expect(find.text('Symbol'), findsWidgets);
    expect(find.text('Market'), findsWidgets);

    // 2) Sub-tab selection preserved (still index 1, NOT reset to Overview).
    expect(controllerOf().index, 1);
    expect(find.text('Market indices'), findsNothing); // did NOT jump to Overview
  });
}
