import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:stock_app/core/localization/app_locales.dart';
import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/features/home/widgets/index_chart.dart';

Widget _wrap() => EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.fallback,
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const Scaffold(
            body: SingleChildScrollView(child: IndexChart()),
          ),
        ),
      ),
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  // Only the first testWidgets in a file mounts EasyLocalization's child, so
  // every widget assertion has to live in this one test.
  testWidgets('Renders VN-INDEX, scrubs the trackball, switches to HNX-INDEX',
      (WidgetTester tester) async {
    // Phone-sized surface: the point under the plot's centre, and so the
    // tooltip values asserted below, depend on the chart's width.
    tester.view.physicalSize = const Size(390 * 3, 460 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Defaults to the first index; the header carries the headline number.
    expect(find.byType(SfCartesianChart), findsOneWidget);
    expect(find.text('1,278.45'), findsOneWidget);
    expect(find.text('+8.62 (+0.68%)'), findsOneWidget);
    expect(find.text('KL 745.0M'), findsOneWidget);
    expect(find.text('TC 1,269.83'), findsOneWidget);

    // ActivationMode.singleTap shows the trackball on pointer-down and hides
    // it on pointer-up, so a plain tap() would never leave a tooltip on screen.
    final plot = tester.getRect(find.byType(SfCartesianChart));
    final gesture = await tester.startGesture(plot.center);
    await tester.pump(const Duration(milliseconds: 300));

    // Mid-session point: time, value, and its change against the reference.
    expect(find.text('13:25'), findsOneWidget);
    expect(find.text('1,270.78'), findsOneWidget);
    expect(find.text('+0.95 (+0.08%)'), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('13:25'), findsNothing);

    // Tap a losing index: the header flips to the negative format.
    await tester.tap(find.text('HNX-INDEX'));
    await tester.pumpAndSettle();

    expect(find.text('238.74'), findsOneWidget);
    expect(find.text('-1.12 (-0.47%)'), findsOneWidget);
    expect(find.byType(SfCartesianChart), findsOneWidget);
  });

  test('Intraday series opens at the reference and closes on the index value',
      () {
    for (final index in MockData.indices) {
      final ticks = MockData.intradayOf(index);

      expect(ticks.length, greaterThan(20));
      expect(ticks.first.value, closeTo(index.reference, 0.001));
      expect(ticks.last.value, closeTo(index.value, 0.001));

      // Same series on every call, so a rebuild never reshuffles the line.
      expect(MockData.intradayOf(index), same(ticks));
    }
  });
}
