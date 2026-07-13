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

  /// Yesterday's close: the line the intraday chart is measured against.
  double get reference => value - change;

  bool get isUp => change > 0;
  bool get isDown => change < 0;
}

/// One point on an index's intraday line.
class IndexTick {
  const IndexTick({required this.time, required this.value});

  final DateTime time;
  final double value;
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

  double get ceiling => reference * 1.07;
  double get floor => reference * 0.93;

  factory StockQuote.fromJson(Map<String, dynamic> json) {
    return StockQuote(
      symbol: json['symbol'] as String,
      company: json['company'] as String,
      reference: (json['reference'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      exchange: json['exchange'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'company': company,
      'reference': reference,
      'price': price,
      'change': change,
      'percent': percent,
      'volume': volume,
      'exchange': exchange,
    };
  }

  StockQuote copyWith({
    String? symbol,
    String? company,
    double? reference,
    double? price,
    double? change,
    double? percent,
    double? volume,
    String? exchange,
  }) {
    return StockQuote(
      symbol: symbol ?? this.symbol,
      company: company ?? this.company,
      reference: reference ?? this.reference,
      price: price ?? this.price,
      change: change ?? this.change,
      percent: percent ?? this.percent,
      volume: volume ?? this.volume,
      exchange: exchange ?? this.exchange,
    );
  }
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

enum NotiStatus {
  info,
  success,
  warning,
  error,
}

/// A notification item.
class NotificationItem {
  NotificationItem({
    this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.status,
    this.unread = true,
  });

  final NotiType type;
  final String? id;
  final String title;
  final String message;
  final DateTime createdAt;
  final NotiStatus? status;
  bool unread;
}
