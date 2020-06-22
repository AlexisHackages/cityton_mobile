import 'package:cityton_mobile/models/requestGroupMinimal.dart';
import 'package:cityton_mobile/models/userMinimal.dart';

class Group {
  final int id;
  final String name;
  final UserMinimal creator;
  final List<RequestGroupMinimal> members;
  final List<RequestGroupMinimal> requestsAdhesion;
  final bool hasReachMinSize;
  final bool hasReachMaxSize;
  final UserMinimal supervisor;

  Group(
      {this.id, this.name, this.creator, this.members, this.requestsAdhesion, this.hasReachMinSize, this.hasReachMaxSize, this.supervisor});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int,
      name: json['name'] as String,
      creator: UserMinimal.fromJson(json['creator']),
      hasReachMinSize: json['hasReachMinSize'] as bool,
      hasReachMaxSize: json['hasReachMaxSize'] as bool,
      members: json['members'] == null
          ? RequestGroupMinimalList().users
          : RequestGroupMinimalList.fromJson(json['members']).users,
      requestsAdhesion: json['requestsAdhesion'] == null
          ? RequestGroupMinimalList().users
          : RequestGroupMinimalList.fromJson(json['requestsAdhesion']).users,
      supervisor: json['supervisor'] == null ? null : UserMinimal.fromJson(json['supervisor'])
    );
  }
}

class GroupList {
  final List<Group> groups;

  GroupList({this.groups});

  factory GroupList.fromJson(List<dynamic> parsedJson) {
    List<Group> groups = List<Group>();
    groups = parsedJson.map((i) => Group.fromJson(i)).toList();

    return GroupList(
      groups: groups,
    );
  }
}
