// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
  id: json['id'] as String,
  name: json['name'] as String,
  accountNumber: json['accountNumber'] as String,
  isDefault: json['isDefault'] as bool,
  type:
      $enumDecodeNullable(_$WalletTypeEnumMap, json['type']) ?? WalletType.cash,
  balance: (json['balance'] as num?)?.toDouble() ?? 0,
  stockValue: (json['stockValue'] as num?)?.toDouble() ?? 0,
  currency: json['currency'] as String? ?? 'VND',
);

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'accountNumber': instance.accountNumber,
  'isDefault': instance.isDefault,
  'type': _$WalletTypeEnumMap[instance.type]!,
  'balance': instance.balance,
  'stockValue': instance.stockValue,
  'currency': instance.currency,
};

const _$WalletTypeEnumMap = {
  WalletType.cash: 'cash',
  WalletType.margin: 'margin',
  WalletType.derivatives: 'derivatives',
};
