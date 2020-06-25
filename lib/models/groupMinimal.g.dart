// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupMinimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMinimal _$GroupMinimalFromJson(Map<String, dynamic> json) {
  return GroupMinimal(
    json['id'] as int,
    json['name'] as String,
    json['hasReachMinSize'] as bool,
    json['hasReachMaxSize'] as bool,
    json['supervisor'] == null
        ? null
        : UserMinimal.fromJson(json['supervisor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupMinimalToJson(GroupMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hasReachMinSize': instance.hasReachMinSize,
      'hasReachMaxSize': instance.hasReachMaxSize,
      'supervisor': instance.supervisor,
    };
