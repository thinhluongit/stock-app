import 'package:custom_bottom_nav/custom_bottom_nav.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/data/models/user.dart';

import '../../core/localization/language_switcher.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/mock_data.dart';
import '../menu/menu_page.dart';
import 'tabs/market_tab.dart';
import 'tabs/notifications_tab.dart';
import 'tabs/prices_tab.dart';
import 'tabs/search_tab.dart';
import 'tabs/trading_tab.dart';

/// Main screen: shared AppBar + 5 fixed large tabs via a custom bottom nav.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  // static const _titleKeys = [
  //   'nav.market',
  //   'nav.prices',
  //   'nav.trading',
  //   'nav.search',
  //   'nav.notifications',
  // ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      MarketTab(),
      PricesTab(),
      TradingTab(),
      SearchTab(),
      NotificationsTab(),
    ];

    final defaultWallet = MockData.currentUser.wallets.firstWhere(
      (w) => w.isDefault,
      orElse: () => MockData.currentUser.wallets.first,
    );

    return Scaffold(
      // AppBar chung cho cả 5 tab lớn.
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          children: [
            Row(
              children: [
                Text(widget.user.username, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Container(width: 2, height: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(defaultWallet.id, style: TextStyle(fontSize: 16)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.user.fullName,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          const LanguageSwitcher(),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black,),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MenuPage(username: widget.user.username),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedColor: AppColors.primary,
        items: [
          CustomBottomNavItem(icon: Icons.show_chart, label: 'nav.market'.tr()),
          CustomBottomNavItem(
            icon: Icons.table_chart_outlined,
            activeIcon: Icons.table_chart,
            label: 'nav.prices'.tr(),
          ),
          CustomBottomNavItem(
            icon: Icons.swap_horiz,
            label: 'nav.trading'.tr(),
          ),
          CustomBottomNavItem(icon: Icons.search, label: 'nav.search'.tr()),
          CustomBottomNavItem(
            icon: Icons.notifications_none,
            activeIcon: Icons.notifications,
            label: 'nav.notifications'.tr(),
            badgeCount: MockData.unreadCount,
          ),
        ],
      ),
    );
  }
}
