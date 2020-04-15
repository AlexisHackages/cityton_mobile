import 'package:cityton_mobile/models/enums.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String picture;
  final Role role;
  final String token;
  final int groupId;

  User({this.id, this.username, this.email, this.picture, this.role, this.token, this.groupId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String,
      role: json['role'].runtimeType == int ? Role.values[json['role']] : Role.values.firstWhere((role) => role.toString() == json['role'].split(".").last, orElse: () => null),
      token: json['token'] as String,
      groupId: json['groupId'] as int,
    );
  }

  Map<String, dynamic> toJson() => 
  {
    'id': this.id,
    'username': this.username,
    'email': this.email,
    'picture': this.picture,
    'role': this.role.toString(),
    'token': this.token,
    'groupId': this.groupId,
  };
}