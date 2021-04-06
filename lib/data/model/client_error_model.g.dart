// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientErrorModel _$ClientErrorModelFromJson(Map<String, dynamic> json) {
  return ClientErrorModel(
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$ClientErrorModelToJson(ClientErrorModel instance) =>
    <String, dynamic>{
      'error': instance.error,
    };
