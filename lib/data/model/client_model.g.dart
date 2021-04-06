// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) {
  return ClientModel(
    accounts: (json['accounts'] as List)?.map((e) => e as int)?.toList(),
    age: json['age'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'age': instance.age,
      'name': instance.name,
    };
