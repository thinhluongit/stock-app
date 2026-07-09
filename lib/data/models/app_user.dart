import 'package:json_annotation/json_annotation.dart';

import 'wallet.dart';

part 'app_user.g.dart';

/// An app user. A user can own **many** [Wallet]s (one-to-many).
@JsonSerializable(explicitToJson: true)
class AppUser {
  const AppUser({
    this.id,
    required this.username,
    required this.fullName,
    this.email,
    this.phone,
    this.wallets = const [],
  });

  final String? id;

  /// Login id / customer code, e.g. "038C090201".
  final String username;

  final String fullName;

  final String? email;

  final String? phone;

  /// The wallets (sub-accounts) owned by this user.
  /// Defaults to empty via the constructor when the JSON key is missing.
  final List<Wallet> wallets;

  /// First wallet, treated as the default one (null if the user has none).
  Wallet? get defaultWallet => wallets.isEmpty ? null : wallets.first;

  /// Total assets across all wallets.
  double get totalAsset =>
      wallets.fold(0, (sum, wallet) => sum + wallet.totalAsset);

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    List<Wallet>? wallets,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      wallets: wallets ?? this.wallets,
    );
  }
}
