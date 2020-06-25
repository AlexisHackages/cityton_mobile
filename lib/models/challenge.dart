import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable()
class Challenge {
  final int id;
  final String statement;
  final String title;
  final DateTime createdAt;
  final double succesRate;

  Challenge(
      this.id, this.statement, this.title, this.createdAt, this.succesRate);

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}

class ChallengeList {
  final List<Challenge> challenges;

  ChallengeList({this.challenges});

  factory ChallengeList.fromJson(List<dynamic> parsedJson) {
    List<Challenge> challenges = List<Challenge>();
    challenges = parsedJson.map((i) => Challenge.fromJson(i)).toList();

    return ChallengeList(
      challenges: challenges,
    );
  }
}
