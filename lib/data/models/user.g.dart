// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  username: json['username'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  wallets:
      (json['wallets'] as List<dynamic>?)
          ?.map((e) => Wallet.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'fullName': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
  'wallets': instance.wallets.map((e) => e.toJson()).toList(),
};
