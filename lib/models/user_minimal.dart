class UserMinimal {
  final int id;
  final String username;

  UserMinimal({this.id, this.username});

  factory UserMinimal.fromJson(Map<String, dynamic> json) {
    return UserMinimal(
      id: json['id'] as int,
      username: json['username'] as String
    );
  }
}