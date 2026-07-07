import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/features/home/widgets/overview.dart';

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
        // 'common.derivatives'.tr(),
        'common.coveredWarrant'.tr(),
        // 'market.sector'.tr(),
      ],
      views: [
        Overview(),
        _MoversView(),
        // PlaceholderView(title: 'common.derivatives'.tr(), icon: Icons.timeline),
        _CoveredWarrantViews(),
        // PlaceholderView(
        //     title: 'market.ET'.tr(), icon: Icons.pie_chart_outline),
      ],
    );
  }
}

// class _Overview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text('market.marketIndices'.tr(),
//               style:
//                   const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 150,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             children: [
//               for (final idx in MockData.indices) MarketIndexCard(index: idx),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         _SectionTitle('market.topGainers'.tr()),
//         for (final q in MockData.topGainers) StockQuoteRow(quote: q),
//         const SizedBox(height: 20),
//         _SectionTitle('market.topLosers'.tr()),
//         for (final q in MockData.topLosers) StockQuoteRow(quote: q),
//       ],
//     );
//   }
// }


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

class _CoveredWarrantViews extends StatelessWidget {
  const _CoveredWarrantViews();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _buildListByType(0),
        const SizedBox(height: 8),
        _buildListByType(1),
        const SizedBox(height: 8),
        _buildListByType(2),
      ],
    );
  }

  Widget _buildListByType(int type) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type == 0
                    ? 'common.highestVolume'.tr()
                    : (type == 1
                        ? 'common.topGainers'.tr()
                        : 'common.topLosers'.tr()),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'common.viewMore'.tr(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (_, index) =>
                  StockWarrantRow(quote: MockData.quotes[index]),
            ),
          )
        ],
      ),
    );
  }
}

// class _SectionTitle extends StatelessWidget {
//   const _SectionTitle(this.text);
//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//       child: Row(
//         children: [
//           Container(
//             width: 4,
//             height: 16,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(text,
//               style:
//                   const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }
