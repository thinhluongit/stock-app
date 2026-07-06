import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/models.dart';

/// Card that shows one market index.
class MarketIndexCard extends StatelessWidget {
  const MarketIndexCard({super.key, required this.index});
  final MarketIndex index;

  @override
  Widget build(BuildContext context) {
    final color = changeColor(index.change);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(index.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(formatPrice(index.value),
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 20, color: color)),
            const SizedBox(height: 4),
            Text(
              '${formatChange(index.change)}  ${formatPercent(index.percent)}',
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text('${'common.volume'.tr()}: ${formatVolume(index.volume)}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

/// Header row for a price board table.
class StockQuoteHeader extends StatelessWidget {
  const StockQuoteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600);
    return Container(
      color: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('common.symbol'.tr(), style: style)),
          Expanded(
              flex: 2,
              child: Text('common.price'.tr(),
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 2,
              child: Text('common.change'.tr(),
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 2,
              child: Text('common.percent'.tr(),
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 2,
              child: Text('common.volume'.tr(),
                  textAlign: TextAlign.right, style: style)),
        ],
      ),
    );
  }
}

/// One stock quote row.
class StockQuoteRow extends StatelessWidget {
  const StockQuoteRow({super.key, required this.quote, this.onTap});
  final StockQuote quote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = changeColor(quote.change);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quote.symbol,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(quote.company,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(formatPrice(quote.price),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
            Expanded(
              flex: 2,
              child: Text(formatChange(quote.change),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: color, fontSize: 11)),
            ),
            Expanded(
              flex: 2,
              child: Text(formatPercent(quote.percent),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: color, fontSize: 11)),
            ),
            Expanded(
              flex: 2,
              child: Text(formatVolume(quote.volume),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

class StockWarrantRow extends StatelessWidget {
  const StockWarrantRow({super.key, required this.quote, this.onTap});
  final StockQuote quote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // final color = changeColor(quote.change);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(quote.symbol.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color:
                            quote.change > 0 ? AppColors.up : AppColors.down)),
                const SizedBox(
                  width: 8,
                ),
                Container(width: 2, height: 14, color: Colors.grey[400]),
                const SizedBox(
                  width: 8,
                ),
                Text(quote.exchange.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary)),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(quote.price.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: quote.change > 0
                                ? AppColors.up
                                : AppColors.down)),
                    Text(quote.volume.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(
                  width: 24,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(quote.change.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: quote.change > 0
                                ? AppColors.up
                                : AppColors.down)),
                    Text(quote.percent.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Simple centered placeholder for empty / not-yet-built sub-tabs.
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({super.key, required this.title, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.inbox_outlined,
              size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}
