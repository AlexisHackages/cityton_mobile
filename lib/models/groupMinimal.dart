import 'package:cityton_mobile/models/userMinimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'groupMinimal.g.dart';

@JsonSerializable()
class GroupMinimal {
  final int id;
  final String name;
  final bool hasReachMinSize;
  final bool hasReachMaxSize;
  final UserMinimal supervisor;

  GroupMinimal(this.id, this.name, this.hasReachMinSize, this.hasReachMaxSize,
      this.supervisor);

  factory GroupMinimal.fromJson(Map<String, dynamic> json) =>
      _$GroupMinimalFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMinimalToJson(this);
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
