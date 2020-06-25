import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String email;
  final String picture;
  final int role;
  final String token;
  final int groupId;
  final List<int> groupIdsRequested;

  User(this.id, this.username, this.email, this.picture, this.role, this.token,
      this.groupId, this.groupIdsRequested);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
