import 'package:cityton_mobile/models/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userProfile.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String username;
  final String email;
  final String picture;
  final int role;
  final String groupName;

  UserProfile(this.id, this.username, this.email, this.picture, this.role,
      this.groupName);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

class UserProfileList {
  final List<UserProfile> userProfiles;

  UserProfileList({this.userProfiles});

  factory UserProfileList.fromJson(List<dynamic> parsedJson) {
    List<UserProfile> userProfileList = List<UserProfile>();
    userProfileList = parsedJson.map((i) => UserProfile.fromJson(i)).toList();

    return UserProfileList(
      userProfiles: userProfileList,
    );
  }
}
