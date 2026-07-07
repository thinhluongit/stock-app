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

class _PlaceOrder extends StatefulWidget {
  const _PlaceOrder();

  @override
  State<_PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<_PlaceOrder> {
  bool _isBuySelected = true;
  bool _isNormalOrder = true;
  double _price = 0.0;
  double _volume = 0.0;
  double _excessPrice = 0.0;

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
                filled: _isBuySelected,
                isActive: _isBuySelected,
                onTap: () {
                  setState(() {
                    _isBuySelected = true;
                  });
                },
              ),
            ),
            Expanded(
              child: _SideButton(
                label: 'common.sell'.tr(),
                color: AppColors.down,
                filled: !_isBuySelected,
                isActive: !_isBuySelected,
                onTap: () {
                  setState(() {
                    _isBuySelected = false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SearchResults(
          quotes: MockData.quotes,
          onSelected: (quote) {
            setState(() {
              _price = quote.price;
              _excessPrice = quote.price;
            });
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _SideButton(
                label: 'trading.regularOrder'.tr(),
                color: AppColors.up,
                filled: _isNormalOrder,
                isActive: _isNormalOrder,
                height: 28,
                onTap: () {
                  setState(() {
                    _isNormalOrder = true;
                  });
                },
              ),
            ),
            Expanded(
              child: _SideButton(
                label: 'trading.conditionalOrder'.tr(),
                color: AppColors.up,
                filled: !_isNormalOrder,
                isActive: !_isNormalOrder,
                height: 28,
                onTap: () {
                  setState(() {
                    _isNormalOrder = false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _isNormalOrder ? _buildNormalOrderTab(_excessPrice) : _buildConditionalOrderTab(),
      ],
    );
  }

  Widget _buildNormalOrderTab(double price) {
    final priceValue = price != 0.0 ? price : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildExcessTitle('trading.sellableQuantity'.tr()),
                const SizedBox(height: 4),
                _buildExcessQty(priceValue, true),
                const SizedBox(height: 8),
                _buildExcessQty(priceValue, false),
                const SizedBox(height: 4),
                _buildExcessTitle('trading.buyingPower'.tr()),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueStepper(
                  label: 'common.price'.tr(),
                  value: _price,
                  onIncrease: () {
                    setState(() {
                      _price = (_price + 0.1).roundTo1Decimal();
                    });
                  },
                  onDecrease: () {
                    setState(() {
                      _price = (_price - 0.1)
                          .roundTo1Decimal()
                          .clamp(0.0, double.infinity)
                          .toDouble();
                    });
                  },
                ),
                const SizedBox(height: 8),
                ValueStepper(
                    label: 'common.volume'.tr(),
                    value: _volume,
                    onIncrease: () {
                      setState(() {
                        _volume += 100;
                      });
                    },
                    onDecrease: () {
                      setState(() {
                        _volume = (_volume - 100)
                            .clamp(0.0, double.infinity)
                            .toDouble();
                      });
                    }),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: SizedBox(
                          width: 300,
                          height: 120,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Đặt lệnh thành công',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: _isBuySelected ? AppColors.up : AppColors.down,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _isBuySelected ? 'common.buy'.tr() : 'common.sell'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcessTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildHyphenText(double? price, bool isSellableExcess) {
    int volume = price != null ? 100 : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: isSellableExcess ? Colors.grey[200] : Colors.transparent,
        // borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price != null ? '$price' : '-',
            style: TextStyle(
              color: price != null ? (isSellableExcess ? AppColors.up : AppColors.down) : Colors.grey[200],
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(
            '$volume',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcessQty(double? price, bool isSellableExcess) {
    return Column(
      children: [
        _buildHyphenText(price, isSellableExcess),
        _buildHyphenText(price, isSellableExcess),
        _buildHyphenText(price, isSellableExcess),
      ],
    );
  }

  Widget _buildConditionalOrderTab() {
    return const SizedBox(width: double.infinity, height: 200);
  }
}

class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrease,
    required this.onDecrease,
  });

  final String label;
  final double value;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _StepButton(
            icon: Icons.remove,
            onTap: onDecrease,
          ),
          Container(
            width: 56,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300),
                ),
            child: Text(
              value == 0.0
                  ? '0'
                  : (label == 'common.price'.tr()
                      ? '$value'
                      : value.toDisplayString()),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.grey.shade300),
        // ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.label,
    required this.color,
    required this.filled,
    required this.isActive,
    required this.onTap,
    this.width = double.infinity,
    this.height = 48,
  });
  final String label;
  final Color color;
  final bool filled;
  final bool isActive;
  final double width;
  final double height;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        // padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isActive ? color : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// class _Field extends StatelessWidget {
//   const _Field({required this.label, required this.hint, this.keyboard});
//   final String label;
//   final String hint;
//   final TextInputType? keyboard;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             keyboardType: keyboard,
//             decoration: InputDecoration(hintText: hint),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SearchField extends StatelessWidget {
//   const _SearchField({required this.label, required this.hint, this.keyboard});
//   final String label;
//   final String hint;
//   final TextInputType? keyboard;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 6),
//           TextField(
//             keyboardType: keyboard,
//             decoration: InputDecoration(hintText: hint),
//             onChanged: (value) {
//               setState(() {
//                 // Handle search input change
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

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
        OrderStatus.pending => (
            'trading.statusPending'.tr(),
            AppColors.reference
          ),
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
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            v,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      );
}

class _SearchResults extends StatefulWidget {
  const _SearchResults({
    required this.quotes,
    required this.onSelected,
  });

  final List<StockQuote> quotes;
  final ValueChanged<StockQuote> onSelected;

  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  final TextEditingController _controller = TextEditingController();

  String _query = '';
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.quotes
        .where((q) =>
            q.symbol.toLowerCase().contains(_query.toLowerCase()) ||
            q.company.toLowerCase().contains(_query.toLowerCase()))
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) {
            final upper = value.toUpperCase();

            // Nếu người dùng nhập chữ thường thì đổi thành chữ hoa
            if (upper != value) {
              _controller.value = TextEditingValue(
                text: upper,
                selection: TextSelection.collapsed(offset: upper.length),
              );
            }

            setState(() {
              _query = upper;
              _showSuggestions = upper.isNotEmpty;
            });
          },
          decoration: InputDecoration(
            hintText: 'trading.inputStockHint'.tr(),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          if (results.isEmpty)
            PlaceholderView(
              title: 'common.noResult'.tr(),
              icon: Icons.search_off,
            )
          else
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade200),
                // borderRadius: BorderRadius.circular(8),
                // color:  Colors.grey.shade200
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final quote = results[i];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _controller.text = quote.symbol;
                        _query = quote.symbol;
                        _showSuggestions = false;
                      });

                      widget.onSelected(quote);

                      FocusScope.of(context).unfocus(); // Ẩn bàn phím
                    },
                    child: StockQuoteRow(
                      quote: quote,
                    ),
                  );
                },
              ),
            ),
        ],
      ],
    );
  }
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
                  color:
                      totalProfit >= 0 ? Colors.white : const Color(0xFFFFD1D1),
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
