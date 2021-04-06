// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel(
    balance: (json['balance'] as num)?.toDouble(),
    overdraft: (json['overdraft'] as num)?.toInt(),
  );
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'overdraft': instance.overdraft,
    };
