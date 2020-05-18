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