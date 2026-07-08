import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/services/stock_service.dart';

import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Bảng Giá
class PricesTab extends StatelessWidget {
  PricesTab({super.key});

  final StockService stockService = StockService();

  @override
  Widget build(BuildContext context) {
    return SubTabView(
      tabs: [
        'VN30',
        'HOSE',
        'HNX',
        'UPCOM',
        'prices.favorite'.tr(),
      ],
      views: [
        _Board(
          stockService: stockService,
          quotesFilter: (quotes) =>
              quotes.where((e) => MockData.vn30.contains(e.symbol)).toList(),
        ),
        _Board(
          stockService: stockService,
          quotesFilter: (quotes) =>
              quotes.where((e) => e.exchange == 'HOSE').toList(),
        ),
        _Board(
          stockService: stockService,
          quotesFilter: (quotes) =>
              quotes.where((e) => e.exchange == 'HNX').toList(),
        ),
        _Board(
          stockService: stockService,
          quotesFilter: (quotes) =>
              quotes.where((e) => e.exchange == 'UPCOM').toList(),
        ),
        _Board(
          stockService: stockService,
          quotesFilter: (quotes) => quotes.take(3).toList(),
        ),
      ],
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    super.key,
    required this.stockService,
    required this.quotesFilter,
  });

  final StockService stockService;
  final List<StockQuote> Function(List<StockQuote>) quotesFilter;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StockQuote>>(
      stream: stockService.getRealtimeStocks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final quotes = quotesFilter(snapshot.data!);

        return Column(
          children: [
            const StockQuoteHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (_, i) => StockQuoteRow(
                  quote: quotes[i],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
