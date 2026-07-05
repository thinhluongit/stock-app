import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../widgets/common_widgets.dart';
import '../widgets/sub_tab_view.dart';

/// Tab lớn: Giao Dịch
class TradingTab extends StatelessWidget {
  const TradingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubTabView(
      tabs: [
        'trading.placeOrder'.tr(),
        'trading.todayOrders'.tr(),
        'trading.orderBook'.tr(),
        'trading.portfolio'.tr(),
        'trading.history'.tr(),
      ],
      views: [
        // Non-const: these contain .tr() and must re-translate on locale change.
        _PlaceOrder(),
        _OrderList(orders: MockData.orders),
        _OrderList(orders: MockData.orders),
        _Portfolio(),
        PlaceholderView(
          title: 'trading.tradeHistory'.tr(),
          icon: Icons.history,
        ),
      ],
    );
  }
}

class _PlaceOrder extends StatelessWidget {
  const _PlaceOrder();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _SideButton(
                label: 'common.buy'.tr(),
                color: AppColors.up,
                filled: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SideButton(
                label: 'common.sell'.tr(),
                color: AppColors.down,
                filled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _Field(
          label: 'trading.symbolLabel'.tr(),
          hint: 'trading.symbolHint'.tr(),
        ),
        _Field(
          label: 'trading.quantity'.tr(),
          hint: '0',
          keyboard: TextInputType.number,
        ),
        _Field(
          label: 'trading.orderPrice'.tr(),
          hint: '0.00',
          keyboard: TextInputType.number,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('trading.orderSuccess'.tr()))),
          child: Text('trading.placeOrder'.tr()),
        ),
      ],
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.label,
    required this.color,
    required this.filled,
  });
  final String label;
  final Color color;
  final bool filled;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.hint, this.keyboard});
  final String label;
  final String hint;
  final TextInputType? keyboard;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TextField(
            keyboardType: keyboard,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders});
  final List<StockOrder> orders;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final StockOrder order;

  Color get _sideColor =>
      order.side == OrderSide.buy ? AppColors.up : AppColors.down;

  (String, Color) _status() => switch (order.status) {
    OrderStatus.matched => ('trading.statusMatched'.tr(), AppColors.up),
    OrderStatus.pending => ('trading.statusPending'.tr(), AppColors.reference),
    OrderStatus.canceled => (
      'trading.statusCanceled'.tr(),
      AppColors.textSecondary,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (statusText, statusColor) = _status();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _sideColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (order.side == OrderSide.buy ? 'common.buy' : 'common.sell')
                      .tr(),
                  style: TextStyle(
                    color: _sideColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _kv('common.price'.tr(), formatPrice(order.price)),
              _kv('common.volume'.tr(), formatVolume(order.quantity)),
              _kv('trading.filled'.tr(), '${order.filled}/${order.quantity}'),
              _kv('trading.time'.tr(), order.time),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        k,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
      ),
      const SizedBox(height: 2),
      Text(
        v,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    ],
  );
}

class _Portfolio extends StatelessWidget {
  const _Portfolio();
  @override
  Widget build(BuildContext context) {
    final items = MockData.portfolio;
    final totalValue = items.fold<double>(0, (s, e) => s + e.value);
    final totalProfit = items.fold<double>(0, (s, e) => s + e.profit);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'trading.totalValue'.tr(),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                formatPrice(totalValue),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${'trading.profitLoss'.tr()}: ${formatChange(totalProfit)}',
                style: TextStyle(
                  color: totalProfit >= 0
                      ? Colors.white
                      : const Color(0xFFFFD1D1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final p in items)
          _PortfolioRow(item: p, color: changeColor(p.profit)),
        const SizedBox(height: 8),
        Text(
          'trading.simulatedNote'.tr(),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _PortfolioRow extends StatelessWidget {
  const _PortfolioRow({required this.item, required this.color});
  final PortfolioItem item;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${'common.volume'.tr()}: ${item.quantity} · ${'trading.avg'.tr()}: ${formatPrice(item.avgPrice)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(item.marketPrice),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatPercent(item.profitPercent),
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
