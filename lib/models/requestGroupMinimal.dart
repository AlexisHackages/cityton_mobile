import 'package:cityton_mobile/models/userMinimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requestGroupMinimal.g.dart';

@JsonSerializable()
class RequestGroupMinimal {
  final int id;
  final UserMinimal user;

  RequestGroupMinimal(this.id, this.user);

  factory RequestGroupMinimal.fromJson(Map<String, dynamic> json) =>
      _$RequestGroupMinimalFromJson(json);
  Map<String, dynamic> toJson() => _$RequestGroupMinimalToJson(this);
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
