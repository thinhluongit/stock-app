import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

/// Loại tiểu khoản / ví.
enum WalletType {
  @JsonValue('cash')
  cash, // tài khoản thường
  @JsonValue('margin')
  margin, // tài khoản ký quỹ
  @JsonValue('derivatives')
  derivatives, // tài khoản phái sinh
}

/// A wallet (sub-account) belonging to a [User].
///
/// One user can own many wallets (cash / margin / derivatives...).
@JsonSerializable()
class Wallet {
  const Wallet({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.isDefault,
    this.type = WalletType.cash,
    this.balance = 0,
    this.stockValue = 0,
    this.currency = 'VND',
  });

  /// Wallet id.
  final String id;

  final String name;

  final String accountNumber;

  final bool isDefault;

  final WalletType type;

  /// Số dư tiền mặt.
  final double balance;

  /// Giá trị chứng khoán đang nắm giữ.
  final double stockValue;

  /// Đơn vị tiền tệ (mặc định VND — lấy từ default của constructor khi JSON thiếu).
  final String currency;

  /// Tổng tài sản của ví = tiền mặt + giá trị chứng khoán.
  double get totalAsset => balance + stockValue;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  Wallet copyWith({
    String? id,
    String? name,
    String? accountNumber,
    bool? isDefault,
    WalletType? type,
    double? balance,
    double? stockValue,
    String? currency,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      isDefault: isDefault ?? this.isDefault,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      stockValue: stockValue ?? this.stockValue,
      currency: currency ?? this.currency,
    );
  }
}
