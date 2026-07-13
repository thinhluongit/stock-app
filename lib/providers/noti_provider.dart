import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_app/data/mock/mock_data.dart';
import 'package:stock_app/data/models/models.dart';
import 'package:uuid/uuid.dart';

class NotificationProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<NotificationItem> _notifications = List.of(MockData.notifications);

  /// Danh sách thông báo (chỉ đọc)
  UnmodifiableListView<NotificationItem> get notifications =>
      UnmodifiableListView(_notifications);

  /// Số thông báo chưa đọc
  int get unreadCount => _notifications.where((e) => e.unread).length;

  /// Thêm notification bất kỳ
  void addNotification({
    required String title,
    required String content,
    NotiType type = NotiType.transaction,
    NotiStatus? status,
  }) {
    _notifications.insert(
      0,
      NotificationItem(
        id: _uuid.v4(),
        title: title,
        message: content,
        time: DateTime.now().toIso8601String(),
        type: type,
        status: status ?? NotiStatus.error,
      ),
    );

    notifyListeners();
  }

  /// Đặt lệnh thành công
  void addOrderSuccess(StockOrder order) {
    addNotification(
      title: 'Đặt lệnh thành công',
      content:
          '${order.side == OrderSide.buy ? 'common.buy'.tr().toUpperCase() : 'common.sell'.tr().toUpperCase()} '
          '${order.quantity} ${order.symbol} '
          '${'common.price'.tr().toLowerCase()} ${order.price}',
      type: NotiType.transaction,
    );
  }

  /// Đặt lệnh thất bại
  void addOrderFailed(String reason) {
    addNotification(
      title: 'Đặt lệnh thất bại',
      content: reason,
      // type: NotificationType.error,
    );
  }

  /// Đánh dấu đã đọc
  void markAsRead(String id) {
    final index = _notifications.indexWhere((e) => e.id == id);

    if (index == -1) return;

    _notifications[index].unread = false;
    notifyListeners();
  }

  /// Đánh dấu tất cả đã đọc
  void markAllAsRead() {
    for (final item in _notifications) {
      item.unread = false;
    }

    notifyListeners();
  }

  /// Xóa một notification
  void remove(String id) {
    _notifications.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Xóa toàn bộ
  void clear() {
    _notifications.clear();
    notifyListeners();
  }
}
