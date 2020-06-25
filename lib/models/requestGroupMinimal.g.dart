// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requestGroupMinimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestGroupMinimal _$RequestGroupMinimalFromJson(Map<String, dynamic> json) {
  return RequestGroupMinimal(
    json['id'] as int,
    json['user'] == null
        ? null
        : UserMinimal.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RequestGroupMinimalToJson(
        RequestGroupMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
    };
