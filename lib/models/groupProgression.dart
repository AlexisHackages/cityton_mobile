import 'package:cityton_mobile/models/challengeMinimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'groupProgression.g.dart';

@JsonSerializable()
class GroupProgression {
  final int groupId;
  final double progression;
  final List<ChallengeMinimal> inProgress;
  final List<ChallengeMinimal> succeed;
  final List<ChallengeMinimal> failed;

  GroupProgression(this.groupId, this.progression, this.inProgress,
      this.succeed, this.failed);

  factory GroupProgression.fromJson(Map<String, dynamic> json) =>
      _$GroupProgressionFromJson(json);
  Map<String, dynamic> toJson() => _$GroupProgressionToJson(this);
}
