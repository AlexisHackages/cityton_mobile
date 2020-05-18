import 'package:cityton_mobile/models/userMinimal.dart';

class RequestGroupMinimal {
  final int id;
  final UserMinimal user;

  RequestGroupMinimal({this.id, this.user});

  factory RequestGroupMinimal.fromJson(Map<String, dynamic> json) {
    return RequestGroupMinimal(
      id: json['id'] as int,
      user: UserMinimal.fromJson(json['user'])
    );
  }
}

class RequestGroupMinimalList {
  final List<RequestGroupMinimal> users;

  RequestGroupMinimalList({this.users});

  factory RequestGroupMinimalList.fromJson(List<dynamic> parsedJson) {

    List<RequestGroupMinimal> users = List<RequestGroupMinimal>();
    users = parsedJson.map((i) => RequestGroupMinimal.fromJson(i)).toList();

    return RequestGroupMinimalList(
       users: users,
    );
  }
}