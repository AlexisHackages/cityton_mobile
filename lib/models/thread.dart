import 'package:cityton_mobile/models/user_minimal.dart';

class Thread {
  final int discussionId;
  final String name;
  final List<UserMinimal> participants;

  Thread({this.discussionId, this.name, this.participants});

  factory Thread.fromJson(Map<String, dynamic> json) {
    var list = json['participants'] as List;
    List<UserMinimal> users = list.map((i) => UserMinimal.fromJson(i)).toList();
    return Thread(
      discussionId: json['discussionId'] as int,
      name: json['name'] as String,
      participants: users
    );
  }
}
