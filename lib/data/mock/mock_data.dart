import '../models/models.dart';
import '../models/user.dart';
import '../models/wallet.dart';

/// Static mock data used across the app (no API).
class MockData {
  MockData._();

  /// Mock account (customer) code shown on the menu screen.
  static const String accountCode = '038C090201';

  /// Mock signed-in user with several wallets (sub-accounts).
  static const User currentUser = User(
    id: 'u001',
    username: accountCode,
    fullName: 'Lương Trường Thịnh',
    email: 'thinh@gmail.com',
    phone: '0377355633',
    wallets: [
      Wallet(
        id: 'w01',
        name: 'Tài khoản thường',
        accountNumber: '$accountCode-01',
        isDefault: true,
        type: WalletType.cash,
        balance: 125500000,
        stockValue: 342800000,
      ),
      Wallet(
        id: 'w02',
        name: 'Tài khoản ký quỹ',
        accountNumber: '$accountCode-02',
        isDefault: false,
        type: WalletType.margin,
        balance: 48200000,
        stockValue: 156000000,
      ),
      Wallet(
        id: 'w03',
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

  static const List<NotificationItem> notifications = [
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
}
