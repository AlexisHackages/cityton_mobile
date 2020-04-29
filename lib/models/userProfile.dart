import 'package:cityton_mobile/models/enums.dart';

class UserProfile {
  final int id;
  final String username;
  final String email;
  final String picture;
  final Role role;
  final String groupName;

  UserProfile(
      {this.id,
      this.username,
      this.email,
      this.picture,
      this.role,
      this.groupName});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String,
      role: Role.values[json['role']],
      groupName: json['groupName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'username': this.username,
        'email': this.email,
        'picture': this.picture,
        'role': this.role.toString(),
        'groupName': this.groupName,
      };
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
