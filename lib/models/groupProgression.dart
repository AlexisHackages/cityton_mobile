import 'package:cityton_mobile/models/challengeMinimal.dart';

class GroupProgression {
  final int groupId;
  final double progression;
  final List<ChallengeMinimal> inProgress;
  final List<ChallengeMinimal> succeed;
  final List<ChallengeMinimal> failed;


  GroupProgression({this.groupId, this.progression, this.inProgress, this.succeed, this.failed});

  factory GroupProgression.fromJson(Map<String, dynamic> json) {
    return GroupProgression(
      groupId: json['groupId'] as int,
      progression: json['progression'] as double,
      inProgress: ChallengeMinimalList.fromJson(json['inProgress']).challenges,
      succeed: ChallengeMinimalList.fromJson(json['succeed']).challenges,
      failed: ChallengeMinimalList.fromJson(json['failed']).challenges,
    );
  }
}