// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userMinimal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMinimal _$UserMinimalFromJson(Map<String, dynamic> json) {
  return UserMinimal(
    json['id'] as int,
    json['username'] as String,
    json['profilePicture'] as String,
  );
}

Map<String, dynamic> _$UserMinimalToJson(UserMinimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profilePicture': instance.profilePicture,
    };
