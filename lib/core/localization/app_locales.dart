import 'package:flutter/widgets.dart';

/// Supported languages & shared localization config.
class AppLocales {
  AppLocales._();

  static const Locale vi = Locale('vi');
  static const Locale en = Locale('en');
  static const Locale zh = Locale('zh');
  static const Locale ja = Locale('ja');

  /// Vietnamese is the default / fallback.
  static const Locale fallback = vi;

  static const List<Locale> supported = [vi, en, zh, ja];

  /// Where the JSON translation files live.
  static const String path = 'assets/translations';

  /// Display metadata for each locale (flag emoji + i18n key for its name).
  static const Map<String, ({String flag, String nameKey})> meta = {
    'vi': (flag: '🇻🇳', nameKey: 'language.vi'),
    'en': (flag: '🇬🇧', nameKey: 'language.en'),
    'zh': (flag: '🇨🇳', nameKey: 'language.zh'),
    'ja': (flag: '🇯🇵', nameKey: 'language.ja'),
  };
}
