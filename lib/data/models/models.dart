// Simple immutable data models for the mock stock app.

/// A market index (VN-Index, HNX-Index, ...).
class MarketIndex {
  const MarketIndex({
    required this.name,
    required this.value,
    required this.change,
    required this.percent,
    required this.volume,
  });

  final String name;
  final double value;
  final double change;
  final double percent;
  final double volume; // shares
}

/// A single stock quote row shown on the price board.
class StockQuote {
  const StockQuote({
    required this.symbol,
    required this.company,
    required this.reference,
    required this.price,
    required this.change,
    required this.percent,
    required this.volume,
    required this.exchange,
  });

  final String symbol;
  final String company;
  final double reference;
  final double price;
  final double change;
  final double percent;
  final double volume;
  final String exchange; // HOSE / HNX / UPCOM

  double get ceiling => (reference * 1.07);
  double get floor => (reference * 0.93);
}

enum OrderSide { buy, sell }

enum OrderStatus { matched, pending, canceled }

/// A trading order.
class StockOrder {
  const StockOrder({
    required this.symbol,
    required this.side,
    required this.price,
    required this.quantity,
    required this.filled,
    required this.status,
    required this.time,
  });

  final String symbol;
  final OrderSide side;
  final double price;
  final int quantity;
  final int filled;
  final OrderStatus status;
  final String time;
}

/// A holding in the portfolio.
class PortfolioItem {
  const PortfolioItem({
    required this.symbol,
    required this.quantity,
    required this.avgPrice,
    required this.marketPrice,
  });

  final String symbol;
  final int quantity;
  final double avgPrice;
  final double marketPrice;

  double get value => quantity * marketPrice;
  double get cost => quantity * avgPrice;
  double get profit => value - cost;
  double get profitPercent => cost == 0 ? 0 : (profit / cost) * 100;
}

enum NotiType { system, transaction, priceAlert, news }

/// A notification item.
class NotificationItem {
  const NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.unread = false,
  });

  final NotiType type;
  final String title;
  final String message;
  final String time;
  final bool unread;
}
