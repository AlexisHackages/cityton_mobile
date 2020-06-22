import 'package:cityton_mobile/models/userMinimal.dart';

class GroupMinimal {
  final int id;
  final String name;
  final bool hasReachMinSize;
  final bool hasReachMaxSize;
  final UserMinimal supervisor;


  GroupMinimal({this.id, this.name, this.hasReachMinSize, this.hasReachMaxSize, this.supervisor});

  factory GroupMinimal.fromJson(Map<String, dynamic> json) {
    return GroupMinimal(
      id: json['id'] as int,
      name: json['name'] as String,
      hasReachMinSize: json['hasReachMinSize'] as bool,
      hasReachMaxSize: json['hasReachMaxSize'] as bool,
      supervisor: json['supervisor'] == null ? null : UserMinimal.fromJson(json['supervisor'])
    );
  }
}

class GroupMinimalList {
  final List<GroupMinimal> groups;

  GroupMinimalList({this.groups});

  factory GroupMinimalList.fromJson(List<dynamic> parsedJson) {

    List<GroupMinimal> groups = List<GroupMinimal>();
    groups = parsedJson.map((i) => GroupMinimal.fromJson(i)).toList();

    return GroupMinimalList(
       groups: groups,
    );
  }
}
