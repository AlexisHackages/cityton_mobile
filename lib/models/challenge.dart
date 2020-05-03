class Challenge {
  final int id;
  final String statement;
  final String title;
  final DateTime createdAt;
  final double succesRate;


  Challenge({this.id, this.statement, this.title, this.createdAt, this.succesRate});

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as int,
      statement: json['statement'] as String,
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
      succesRate: json['succesRate'] as double,
    );
  }
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
