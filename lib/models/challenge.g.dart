// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) {
  return Challenge(
    json['id'] as int,
    json['statement'] as String,
    json['title'] as String,
    json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    (json['succesRate'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'statement': instance.statement,
      'title': instance.title,
      'createdAt': instance.createdAt?.toIso8601String(),
      'succesRate': instance.succesRate,
    };
