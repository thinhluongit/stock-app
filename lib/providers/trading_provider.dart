import 'package:flutter/foundation.dart';
import 'package:notification_center/notification_center.dart';
import 'package:stock_app/core/utils/formatters.dart';
import 'package:stock_app/data/core/events.dart';
import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/data/models/models.dart';

/// Kết quả kiểm tra hợp lệ của form đặt lệnh.
///
/// UI dùng giá trị này để tra ra message i18n tương ứng, tránh việc
/// provider phải phụ thuộc vào tầng localization.
enum OrderValidation {
  ok,
  noSymbol,
  invalidPrice,
  priceOutOfRange,
  invalidVolume,
}

/// Quản lý toàn bộ trạng thái của luồng đặt lệnh (tab "Đặt lệnh"):
/// - Mã đang chọn, giá, khối lượng, chiều mua/bán.
/// - Kiểm tra hợp lệ trước khi gửi.
/// - Gửi lệnh (giả lập API) rồi thêm vào danh sách "Lệnh trong ngày".
class TradingProvider extends ChangeNotifier {
  static const double _priceStep = 0.1;
  static const int _volumeStep = 100;

  OrderSide _side = OrderSide.buy;
  StockQuote? _selectedQuote;
  double _price = 0;
  int _volume = 0;
  bool _isPlacing = false;

  /// Khởi tạo từ dữ liệu mock; lệnh mới đặt sẽ được chèn lên đầu danh sách.
  final List<StockOrder> _todayOrders = List.of(MockData.orders);

  OrderSide get side => _side;
  bool get isBuy => _side == OrderSide.buy;
  StockQuote? get selectedQuote => _selectedQuote;
  double get price => _price;
  int get volume => _volume;
  bool get isPlacing => _isPlacing;
  List<StockOrder> get todayOrders => List.unmodifiable(_todayOrders);

  void selectSide(OrderSide side) {
    if (_side == side) return;
    _side = side;
    notifyListeners();
  }

  /// Chọn mã từ ô tìm kiếm: tự điền giá đặt bằng giá khớp gần nhất.
  void selectQuote(StockQuote quote) {
    _selectedQuote = quote;
    _price = quote.price;
    notifyListeners();
  }

  void increasePrice() {
    _price = (_price + _priceStep).roundTo1Decimal();
    notifyListeners();
  }

  void decreasePrice() {
    _price = (_price - _priceStep)
        .roundTo1Decimal()
        .clamp(0.0, double.infinity)
        .toDouble();
    notifyListeners();
  }

  void increaseVolume() {
    _volume += _volumeStep;
    notifyListeners();
  }

  void decreaseVolume() {
    final next = _volume - _volumeStep;
    _volume = next < 0 ? 0 : next;
    notifyListeners();
  }

  /// Kiểm tra hợp lệ form trước khi cho phép đặt lệnh.
  OrderValidation validate() {
    final quote = _selectedQuote;
    if (quote == null) return OrderValidation.noSymbol;
    if (_price <= 0) return OrderValidation.invalidPrice;
    // Giá đặt phải nằm trong khoảng sàn – trần của mã.
    if (_price < quote.floor || _price > quote.ceiling) {
      return OrderValidation.priceOutOfRange;
    }
    if (_volume <= 0 || _volume % _volumeStep != 0) {
      return OrderValidation.invalidVolume;
    }
    return OrderValidation.ok;
  }

  /// Gửi lệnh lên sàn (giả lập API), sau đó chèn vào đầu danh sách lệnh
  /// trong ngày với trạng thái "Chờ khớp". Giả định form đã hợp lệ
  /// (UI phải gọi [validate] trước).
  Future<StockOrder> placeOrder() async {
    _isPlacing = true;
    notifyListeners();

    // Giả lập độ trễ gọi API đặt lệnh.
    await Future.delayed(const Duration(milliseconds: 600));

    final order = StockOrder(
      symbol: _selectedQuote!.symbol,
      side: _side,
      price: _price,
      quantity: _volume,
      filled: 0,
      status: OrderStatus.pending,
      time: _formatNow(),
    );
    _todayOrders.insert(0, order);

    _isPlacing = false;
    notifyListeners();

    NotificationCenter().notify(
      AppEvents.orderPlaced,
      data: order,
    );

    debugPrint("===== NOTIFY orderPlaced =====");

    return order;
  }

  /// Xoá form về trạng thái trống (giữ nguyên chiều mua/bán đang chọn).
  void resetForm() {
    _selectedQuote = null;
    _price = 0;
    _volume = 0;
    notifyListeners();
  }

  String _formatNow() {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
  }
}
