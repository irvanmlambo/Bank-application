// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['kind'] as String,
    json['localId'] as String,
    json['email'] as String,
    json['displayName'] as String,
    json['idToken'] as String,
    json['registered'] as bool,
    json['refreshToken'] as String,
    json['expiresIn'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'kind': instance.kind,
      'localId': instance.localId,
      'email': instance.email,
      'displayName': instance.displayName,
      'idToken': instance.idToken,
      'registered': instance.registered,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
