import 'package:stock_app/data/models/models.dart';

enum OrderType {
  limit, // LO
  market, // MP/MTL/MOK...
}

enum OrderStatus {
  pending,        // Chờ gửi
  sending,        // Đang gửi
  accepted,       // Đã nhận
  partialFilled,  // Khớp một phần
  filled,         // Khớp hết
  cancelled,      // Đã hủy
  rejected,       // Bị từ chối
}

class Order {
  const Order({
    required this.id,
    required this.accountNo,
    required this.symbol,
    required this.side,
    required this.orderType,
    required this.price,
    required this.volume,
    required this.orderTime,
    this.filledVolume = 0,
    this.averagePrice = 0,
    this.status = OrderStatus.pending,
    this.message,
  });

  /// Mã lệnh
  final String id;

  /// Tài khoản giao dịch
  final String accountNo;

  /// Mã chứng khoán
  final String symbol;

  /// Mua / Bán
  final OrderSide side;

  /// LO / MP...
  final OrderType orderType;

  /// Giá đặt
  final double price;

  /// Khối lượng đặt
  final int volume;

  /// Khối lượng đã khớp
  final int filledVolume;

  /// Giá khớp bình quân
  final double averagePrice;

  /// Thời gian đặt
  final DateTime orderTime;

  /// Trạng thái
  final OrderStatus status;

  /// Thông báo từ hệ thống
  final String? message;

  /// Khối lượng còn lại
  int get remainingVolume => volume - filledVolume;

  /// Đã khớp hết?
  bool get isFilled => filledVolume >= volume;

  /// Giá trị đặt lệnh
  double get orderValue => price * volume;

  Order copyWith({
    String? id,
    String? accountNo,
    String? symbol,
    OrderSide? side,
    OrderType? orderType,
    double? price,
    int? volume,
    int? filledVolume,
    double? averagePrice,
    DateTime? orderTime,
    OrderStatus? status,
    String? message,
  }) {
    return Order(
      id: id ?? this.id,
      accountNo: accountNo ?? this.accountNo,
      symbol: symbol ?? this.symbol,
      side: side ?? this.side,
      orderType: orderType ?? this.orderType,
      price: price ?? this.price,
      volume: volume ?? this.volume,
      filledVolume: filledVolume ?? this.filledVolume,
      averagePrice: averagePrice ?? this.averagePrice,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}