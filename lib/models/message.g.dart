// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['id'] as int,
    json['content'] as String,
    json['media'] == null
        ? null
        : MediaMinimal.fromJson(json['media'] as Map<String, dynamic>),
    json['author'] == null
        ? null
        : UserMinimal.fromJson(json['author'] as Map<String, dynamic>),
    json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    json['discussionId'] as int,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'media': instance.media,
      'author': instance.author,
      'createdAt': instance.createdAt?.toIso8601String(),
      'discussionId': instance.discussionId,
    };
