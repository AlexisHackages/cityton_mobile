class ChallengeMinimal {
  final int id;
  final String statement;
  final String title;


  ChallengeMinimal({this.id, this.statement, this.title});

  factory ChallengeMinimal.fromJson(Map<String, dynamic> json) {
    return ChallengeMinimal(
      id: json['id'] as int,
      statement: json['statement'] as String,
      title: json['title'],
    );
  }
}

class ChallengeMinimalList {
  final List<ChallengeMinimal> challenges;

  ChallengeMinimalList({this.challenges});

  factory ChallengeMinimalList.fromJson(List<dynamic> parsedJson) {

    List<ChallengeMinimal> challenges = List<ChallengeMinimal>();
    challenges = parsedJson.map((i) => ChallengeMinimal.fromJson(i)).toList();

    return ChallengeMinimalList(
       challenges: challenges,
    );
  }
}
