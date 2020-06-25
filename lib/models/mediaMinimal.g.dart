// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mediaMinimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaMinimal _$MediaMinimalFromJson(Map<String, dynamic> json) {
  return MediaMinimal(
    json['id'] as int,
    json['url'] as String,
    json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$MediaMinimalToJson(MediaMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
