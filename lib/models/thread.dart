import 'package:cityton_mobile/models/user_minimal.dart';

class Thread {
  final int discussionId;
  final String name;
  final List<UserMinimal> participants;

  Thread(this.discussionId, this.name, this.participants);
}