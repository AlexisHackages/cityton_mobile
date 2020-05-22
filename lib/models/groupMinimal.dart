class GroupMinimal {
  final int id;
  final String name;
  final bool hasReachMaxSize;


  GroupMinimal({this.id, this.name, this.hasReachMaxSize});

  factory GroupMinimal.fromJson(Map<String, dynamic> json) {
    return GroupMinimal(
      id: json['id'] as int,
      name: json['name'] as String,
      hasReachMaxSize: json['hasReachMaxSize'] as bool,
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
