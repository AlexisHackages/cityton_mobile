// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) {
  return Thread(
    json['discussionId'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'discussionId': instance.discussionId,
      'name': instance.name,
    };
