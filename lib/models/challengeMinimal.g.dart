// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challengeMinimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeMinimal _$ChallengeMinimalFromJson(Map<String, dynamic> json) {
  return ChallengeMinimal(
    json['id'] as int,
    json['statement'] as String,
    json['title'] as String,
  );
}

Map<String, dynamic> _$ChallengeMinimalToJson(ChallengeMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statement': instance.statement,
      'title': instance.title,
    };
