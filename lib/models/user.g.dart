// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['username'] as String,
    json['email'] as String,
    json['picture'] as String,
    json['role'] as int,
    json['token'] as String,
    json['groupId'] as int,
    (json['groupIdsRequested'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'picture': instance.picture,
      'role': instance.role,
      'token': instance.token,
      'groupId': instance.groupId,
      'groupIdsRequested': instance.groupIdsRequested,
    };