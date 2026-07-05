import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Tìm Kiếm
class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubTabView(
      tabs: [
        'common.all'.tr(),
        'common.stock'.tr(),
        'common.coveredWarrant'.tr(),
        'common.derivatives'.tr(),
        'common.news'.tr(),
      ],
      views: [
        _SearchResults(quotes: MockData.quotes),
        _SearchResults(quotes: MockData.quotes),
        PlaceholderView(
            title: 'common.coveredWarrant'.tr(),
            icon: Icons.confirmation_num_outlined),
        PlaceholderView(title: 'common.derivatives'.tr(), icon: Icons.timeline),
        PlaceholderView(
            title: 'common.news'.tr(), icon: Icons.article_outlined),
      ],
    );
  }
}

class _SearchResults extends StatefulWidget {
  const _SearchResults({required this.quotes});
  final List<StockQuote> quotes;
  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty
        ? widget.quotes
        : widget.quotes
            .where((q) =>
                q.symbol.toLowerCase().contains(_query.toLowerCase()) ||
                q.company.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'search.hint'.tr(),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
            ),
          ),
        ),
        if (results.isEmpty)
          Expanded(
            child: PlaceholderView(
                title: 'common.noResult'.tr(), icon: Icons.search_off),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) => StockQuoteRow(quote: results[i]),
            ),
          ),
      ],
    );
  }
}
