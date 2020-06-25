// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupProgression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupProgression _$GroupProgressionFromJson(Map<String, dynamic> json) {
  return GroupProgression(
    json['groupId'] as int,
    (json['progression'] as num)?.toDouble(),
    (json['inProgress'] as List)
        ?.map((e) => e == null
            ? null
            : ChallengeMinimal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['succeed'] as List)
        ?.map((e) => e == null
            ? null
            : ChallengeMinimal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['failed'] as List)
        ?.map((e) => e == null
            ? null
            : ChallengeMinimal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupProgressionToJson(GroupProgression instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'progression': instance.progression,
      'inProgress': instance.inProgress,
      'succeed': instance.succeed,
      'failed': instance.failed,
    };
