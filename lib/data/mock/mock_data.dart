import 'dart:math';

import 'package:stock_app/data/models/menu_item.dart';
import 'package:stock_app/features/menu/cash_transaction/internal_transfer_page.dart';

import '../models/models.dart';
import '../models/app_user.dart';
import '../models/wallet.dart';

/// Static mock data used across the app (no API).
class MockData {
  MockData._();

  /// Mock account (customer) code shown on the menu screen.
  static const String accountCode = '038C090201';

  /// Mock signed-in user with several wallets (sub-accounts).
  static const AppUser currentUser = AppUser(
    id: 'u001',
    username: accountCode,
    fullName: 'Lương Trường Thịnh',
    email: 'thinh@gmail.com',
    phone: '0377355633',
    wallets: [
      Wallet(
        id: '01',
        name: 'Tài khoản thường',
        accountNumber: '$accountCode-01',
        isDefault: true,
        type: WalletType.cash,
        balance: 125500000,
        stockValue: 342800000,
      ),
      Wallet(
        id: '02',
        name: 'Tài khoản ký quỹ',
        accountNumber: '$accountCode-02',
        isDefault: false,
        type: WalletType.margin,
        balance: 48200000,
        stockValue: 156000000,
      ),
      Wallet(
        id: '03',
        name: 'Tài khoản phái sinh',
        accountNumber: '$accountCode-03',
        isDefault: false,
        type: WalletType.derivatives,
        balance: 30000000,
        stockValue: 0,
      ),
    ],
  );

  static const List<MarketIndex> indices = [
    MarketIndex(
      name: 'VN-INDEX',
      value: 1278.45,
      change: 8.62,
      percent: 0.68,
      volume: 745000000,
    ),
    MarketIndex(
      name: 'VN30',
      value: 1305.12,
      change: 11.30,
      percent: 0.87,
      volume: 312000000,
    ),
    MarketIndex(
      name: 'HNX-INDEX',
      value: 238.74,
      change: -1.12,
      percent: -0.47,
      volume: 88000000,
    ),
    MarketIndex(
      name: 'UPCOM',
      value: 94.21,
      change: 0.35,
      percent: 0.37,
      volume: 41000000,
    ),
  ];

  static MarketIndex indexByName(String name) =>
      indices.firstWhere((i) => i.name == name);

  /// The HOSE trading session, sampled every 5 minutes. The lunch break
  /// (11:30–13:00) is simply absent, so a category axis draws no flat gap.
  static List<DateTime> get _sessionTimes => [
        for (var m = 9 * 60; m <= 11 * 60 + 30; m += 5)
          _sessionDay.add(Duration(minutes: m)),
        for (var m = 13 * 60; m <= 14 * 60 + 45; m += 5)
          _sessionDay.add(Duration(minutes: m)),
      ];

  /// Fixed so the mock never depends on the wall clock.
  static final DateTime _sessionDay = DateTime(2026, 7, 9);

  static final Map<String, List<IndexTick>> _intradayCache = {};

  /// Intraday line for [index], cached so a rebuild never reshuffles the chart.
  static List<IndexTick> intradayOf(MarketIndex index) =>
      _intradayCache.putIfAbsent(index.name, () => _buildIntraday(index));

  /// A random walk pinned at both ends: it opens at yesterday's close and lands
  /// exactly on [MarketIndex.value], so the chart agrees with the header.
  static List<IndexTick> _buildIntraday(MarketIndex index) {
    final times = _sessionTimes;
    final n = times.length;

    // Seeded off the name so every launch draws the same line.
    final seed =
        index.name.codeUnits.fold<int>(17, (h, c) => (h * 31 + c) & 0x7fffffff);
    final random = Random(seed);

    final stepSize = index.value * 0.0011;
    final walk = List<double>.filled(n, 0);
    for (var i = 1; i < n; i++) {
      walk[i] = walk[i - 1] + (random.nextDouble() - 0.5) * 2 * stepSize;
    }

    // Spread the closing error across the walk instead of jumping at the end.
    final reference = index.reference;
    final drift = index.value - reference - walk[n - 1];

    return [
      for (var i = 0; i < n; i++)
        IndexTick(
          time: times[i],
          value: reference + walk[i] + drift * (i / (n - 1)),
        ),
    ];
  }

  static const List<StockQuote> quotes = [
    StockQuote(
      symbol: 'VNM',
      company: 'CTCP Sữa Việt Nam',
      reference: 68.5,
      price: 70.2,
      change: 1.7,
      percent: 2.48,
      volume: 3120000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'VIC',
      company: 'Tập đoàn Vingroup',
      reference: 42.0,
      price: 41.2,
      change: -0.8,
      percent: -1.90,
      volume: 5450000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'HPG',
      company: 'Tập đoàn Hòa Phát',
      reference: 27.3,
      price: 27.3,
      change: 0.0,
      percent: 0.0,
      volume: 12800000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'FPT',
      company: 'CTCP FPT',
      reference: 132.5,
      price: 135.8,
      change: 3.3,
      percent: 2.49,
      volume: 2210000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'MWG',
      company: 'Thế Giới Di Động',
      reference: 61.0,
      price: 62.9,
      change: 1.9,
      percent: 3.11,
      volume: 4100000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'TCB',
      company: 'Ngân hàng Techcombank',
      reference: 24.8,
      price: 24.1,
      change: -0.7,
      percent: -2.82,
      volume: 8900000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'SSI',
      company: 'CK SSI',
      reference: 35.4,
      price: 36.2,
      change: 0.8,
      percent: 2.26,
      volume: 6700000,
      exchange: 'HOSE',
    ),
    StockQuote(
      symbol: 'SHB',
      company: 'Ngân hàng SHB',
      reference: 11.9,
      price: 11.6,
      change: -0.3,
      percent: -2.52,
      volume: 15300000,
      exchange: 'HNX',
    ),
    StockQuote(
      symbol: 'PVS',
      company: 'PetroVietnam Technical',
      reference: 39.2,
      price: 40.1,
      change: 0.9,
      percent: 2.30,
      volume: 3400000,
      exchange: 'HNX',
    ),
    StockQuote(
      symbol: 'BSR',
      company: 'Lọc hóa dầu Bình Sơn',
      reference: 22.1,
      price: 22.7,
      change: 0.6,
      percent: 2.71,
      volume: 5600000,
      exchange: 'UPCOM',
    ),
  ];

  static List<StockQuote> quotesByExchange(String exchange) =>
      quotes.where((q) => q.exchange == exchange).toList();

  static const List<String> vn30 = [
    'VNM',
    'VIC',
    'HPG',
    'FPT',
    'MWG',
    'TCB',
    'SSI',
  ];

  static List<StockQuote> get vn30Quotes =>
      quotes.where((q) => vn30.contains(q.symbol)).toList();

  static List<StockQuote> get topGainers {
    final list = [...quotes]..sort((a, b) => b.percent.compareTo(a.percent));
    return list.take(5).toList();
  }

  static List<StockQuote> get topLosers {
    final list = [...quotes]..sort((a, b) => a.percent.compareTo(b.percent));
    return list.take(5).toList();
  }

  static const List<StockOrder> orders = [
    StockOrder(
      symbol: 'VNM',
      side: OrderSide.buy,
      price: 70.2,
      quantity: 1000,
      filled: 1000,
      status: OrderStatus.matched,
      time: '09:15:32',
    ),
    StockOrder(
      symbol: 'FPT',
      side: OrderSide.buy,
      price: 135.0,
      quantity: 500,
      filled: 200,
      status: OrderStatus.pending,
      time: '09:32:10',
    ),
    StockOrder(
      symbol: 'TCB',
      side: OrderSide.sell,
      price: 24.5,
      quantity: 2000,
      filled: 0,
      status: OrderStatus.pending,
      time: '10:05:44',
    ),
    StockOrder(
      symbol: 'HPG',
      side: OrderSide.sell,
      price: 27.5,
      quantity: 1500,
      filled: 0,
      status: OrderStatus.canceled,
      time: '10:41:02',
    ),
  ];

  static const List<PortfolioItem> portfolio = [
    PortfolioItem(
      symbol: 'VNM',
      quantity: 1000,
      avgPrice: 66.0,
      marketPrice: 70.2,
    ),
    PortfolioItem(
      symbol: 'FPT',
      quantity: 300,
      avgPrice: 120.0,
      marketPrice: 135.8,
    ),
    PortfolioItem(
      symbol: 'TCB',
      quantity: 2000,
      avgPrice: 25.5,
      marketPrice: 24.1,
    ),
    PortfolioItem(
      symbol: 'MWG',
      quantity: 500,
      avgPrice: 58.0,
      marketPrice: 62.9,
    ),
  ];

  static List<NotificationItem> notifications = [
    NotificationItem(
      type: NotiType.transaction,
      title: 'Khớp lệnh thành công',
      message: 'Lệnh MUA 1,000 VNM giá 70.2 đã khớp toàn bộ.',
      time: '5 phút trước',
      unread: true,
    ),
    NotificationItem(
      type: NotiType.priceAlert,
      title: 'Cảnh báo giá FPT',
      message: 'FPT vừa vượt mốc 135.0 (+2.49%).',
      time: '18 phút trước',
      unread: true,
    ),
    NotificationItem(
      type: NotiType.system,
      title: 'Bảo trì hệ thống',
      message: 'Hệ thống sẽ bảo trì lúc 23:00 hôm nay.',
      time: '1 giờ trước',
    ),
    NotificationItem(
      type: NotiType.news,
      title: 'Tin thị trường',
      message: 'VN-Index tăng phiên thứ 3 liên tiếp, thanh khoản cải thiện.',
      time: '2 giờ trước',
      unread: true,
    ),
    NotificationItem(
      type: NotiType.transaction,
      title: 'Lệnh bị hủy',
      message: 'Lệnh BÁN 1,500 HPG giá 27.5 đã bị hủy.',
      time: '3 giờ trước',
    ),
  ];

  static int get unreadCount => notifications.where((n) => n.unread).length;

  static final Map<String, List<MenuItem>> menus = {
  'menu.cashTransaction': [
    MenuItem(
      labelKey: 'menu.internalTransfer',
      page: const InternalTransferPage(),
    ),
    MenuItem(
      labelKey: 'menu.externalTransfer',
      // page: const ExternalTransferPage(),
      page: const InternalTransferPage(),
    ),
    MenuItem(
      labelKey: 'menu.advanceOnSaleProceeds',
      page: const InternalTransferPage(),
      // page: const AdvanceOnSaleProceedsPage(),
    ),
  ],

  'menu.securitiesTransaction': [
    MenuItem(
      labelKey: 'menu.securitiesTransfer',
      page: const InternalTransferPage(),
      // page: const SecuritiesTransferPage(),
    ),
    MenuItem(
      labelKey: 'menu.rightsSubscription',
      page: const InternalTransferPage(),
      // page: const RightsSubscriptionPage(),
    ),
    MenuItem(
      labelKey: 'menu.corporateActionInquiry',
      page: const InternalTransferPage(),
      // page: const CorporateActionInquiryPage(),
    ),
  ],

  'menu.accountManagement': [
    MenuItem(
      labelKey: 'menu.marginDebt',
      page: const InternalTransferPage(),
      // page: const MarginDebtPage(),
    ),
    MenuItem(
      labelKey: 'menu.cashStatement',
      page: const InternalTransferPage(),
      // page: const CashStatementPage(),
    ),
    MenuItem(
      labelKey: 'menu.securitiesStatement',
      page: const InternalTransferPage(),
      // page: const SecuritiesStatementPage(),
    ),
    MenuItem(
      labelKey: 'menu.orderHistory',
      page: const InternalTransferPage(),
      // page: const OrderHistoryPage(),
    ),
    MenuItem(
      labelKey: 'menu.matchedOrdersSummary',
      page: const InternalTransferPage(),
      // page: const MatchedOrdersSummaryPage(),
    ),
    MenuItem(
      labelKey: 'menu.realizedProfitLoss',
      page: const InternalTransferPage(),
      // page: const RealizedProfitLossPage(),
    ),
  ],

  'menu.utilities': [
    MenuItem(
      labelKey: 'menu.digitalIdentityCertificate',
      page: const InternalTransferPage(),
      // page: const DigitalIdentityCertificatePage(),
    ),
    MenuItem(
      labelKey: 'menu.updateInformationServices',
      page: const InternalTransferPage(),
      // page: const UpdateInformationServicesPage(),
    ),
    MenuItem(
      labelKey: 'menu.marginEligibleList',
      page: const InternalTransferPage(),
      // page: const MarginEligibleListPage(),
    ),
    MenuItem(
      labelKey: 'menu.alertSettings',
      page: const InternalTransferPage(),
      // page: const AlertSettingsPage(),
    ),
  ],

  'menu.settings': [
    MenuItem(
      labelKey: 'menu.personalInformation',
      page: const InternalTransferPage(),
      // page: const PersonalInformationPage(),
    ),
    MenuItem(
      labelKey: 'menu.fontSize',
      page: const InternalTransferPage(),
      // page: const FontSizeSettingPage(),
    ),
    MenuItem(
      labelKey: 'menu.theme',
      page: const InternalTransferPage(),
      // page: const ThemeSettingPage(),
    ),
  ],

  'menu.security': [
    MenuItem(
      labelKey: 'menu.changePassword',
      page: const InternalTransferPage(),
      // page: const ChangePasswordPage(),
    ),
    MenuItem(
      labelKey: 'menu.biometricSettings',
      page: const InternalTransferPage(),
    //   page: const BiometricSettingsPage(),
    ),
  ],

  'menu.support': [
    MenuItem(
      labelKey: 'menu.contact',
      page: const InternalTransferPage(),
      // page: const ContactPage(),
      requiresLogin: false,
    ),
    MenuItem(
      labelKey: 'menu.tradingHandbook',
      page: const InternalTransferPage(),
      // page: const TradingHandbookPage(),
      requiresLogin: false,
    ),
    MenuItem(
      labelKey: 'menu.address',
      page: const InternalTransferPage(),
      // page: const AddressPage(),
      requiresLogin: false,
    ),
  ],
};

}
