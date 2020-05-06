class User {
  final int id;
  final String username;
  final String email;
  final String picture;
  final int role;
  final String token;
  final int groupId;

  User({this.id, this.username, this.email, this.picture, this.role, this.token, this.groupId});

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String,
      role: json['role'] as int,
      token: json['token'] as String,
      groupId: json['groupId'] as int,
    );

    return user;
  }

  Map<String, dynamic> toJson() => 
  {
    'id': this.id,
    'username': this.username,
    'email': this.email,
    'picture': this.picture,
    'role': this.role,
    'token': this.token,
    'groupId': this.groupId,
  };
}