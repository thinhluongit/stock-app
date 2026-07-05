import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Bảng Giá
class PricesTab extends StatelessWidget {
  const PricesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubTabView(
      tabs: ['VN30', 'HOSE', 'HNX', 'UPCOM', 'prices.favorite'.tr()],
      views: [
        _Board(quotes: MockData.vn30Quotes),
        _Board(quotes: MockData.quotesByExchange('HOSE')),
        _Board(quotes: MockData.quotesByExchange('HNX')),
        _Board(quotes: MockData.quotesByExchange('UPCOM')),
        _Board(quotes: MockData.vn30Quotes.take(3).toList()),
      ],
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({required this.quotes});
  final List<StockQuote> quotes;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return PlaceholderView(
        title: 'prices.noSymbol'.tr(),
        icon: Icons.star_border,
      );
    }
    return Column(
      children: [
        StockQuoteHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (_, i) => StockQuoteRow(quote: quotes[i]),
          ),
        ),
      ],
    );
  }
}
