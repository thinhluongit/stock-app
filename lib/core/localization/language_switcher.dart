import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_locales.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.iconColor = Colors.white});

  /// Color of the dropdown arrow (white for the green AppBar by default).
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode;
    final currentMeta = AppLocales.meta[current] ?? AppLocales.meta['vi']!;

    return PopupMenuButton<Locale>(
      tooltip: 'language.title'.tr(),
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (locale) => context.setLocale(locale),
      itemBuilder: (context) => [
        for (final locale in AppLocales.supported) _buildItem(context, locale),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentMeta.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: iconColor, size: 20),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<Locale> _buildItem(BuildContext context, Locale locale) {
    final meta = AppLocales.meta[locale.languageCode]!;
    final selected = context.locale.languageCode == locale.languageCode;
    return PopupMenuItem<Locale>(
      value: locale,
      child: Row(
        children: [
          Text(meta.flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            meta.nameKey.tr(),
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          if (selected) ...[
            const Spacer(),
            Icon(
              Icons.check,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}
