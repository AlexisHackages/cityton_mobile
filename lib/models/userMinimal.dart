import 'package:json_annotation/json_annotation.dart';

part 'userMinimal.g.dart';

@JsonSerializable()
class UserMinimal {
  final int id;
  final String username;
  final String profilePicture;

  UserMinimal(this.id, this.username, this.profilePicture);

  factory UserMinimal.fromJson(Map<String, dynamic> json) =>
      _$UserMinimalFromJson(json);
  Map<String, dynamic> toJson() => _$UserMinimalToJson(this);
}

class UserMinimalList {
  final List<UserMinimal> users;

  UserMinimalList({this.users});

  factory UserMinimalList.fromJson(List<dynamic> parsedJson) {
    List<UserMinimal> users = List<UserMinimal>();
    users = parsedJson.map((i) => UserMinimal.fromJson(i)).toList();

    return UserMinimalList(
      users: users,
    );
  }
}
