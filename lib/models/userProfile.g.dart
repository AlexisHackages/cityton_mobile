// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userProfile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['id'] as int,
    json['username'] as String,
    json['email'] as String,
    json['picture'] as String,
    json['role'] as int,
    json['groupName'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'picture': instance.picture,
      'role': instance.role,
      'groupName': instance.groupName,
    };
