import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_data.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Thị Trường
class MarketTab extends StatelessWidget {
  const MarketTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubTabView(
      tabs: [
        'market.overview'.tr(),
        'common.stock'.tr(),
        'common.derivatives'.tr(),
        'common.coveredWarrant'.tr(),
        'market.sector'.tr(),
      ],
      views: [
        _Overview(),
        _MoversView(),
        PlaceholderView(title: 'common.derivatives'.tr(), icon: Icons.timeline),
        PlaceholderView(
            title: 'common.coveredWarrant'.tr(),
            icon: Icons.confirmation_num_outlined),
        PlaceholderView(
            title: 'market.sectorGroup'.tr(), icon: Icons.pie_chart_outline),
      ],
    );
  }
}

class _Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('market.marketIndices'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final idx in MockData.indices) MarketIndexCard(index: idx),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionTitle('market.topGainers'.tr()),
        for (final q in MockData.topGainers) StockQuoteRow(quote: q),
        const SizedBox(height: 20),
        _SectionTitle('market.topLosers'.tr()),
        for (final q in MockData.topLosers) StockQuoteRow(quote: q),
      ],
    );
  }
}

class _MoversView extends StatelessWidget {
  const _MoversView();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Non-const: header contains .tr() and must re-translate on locale change.
        StockQuoteHeader(),
        Expanded(
          child: ListView(
            children: [
              for (final q in MockData.quotes) StockQuoteRow(quote: q),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }
}
