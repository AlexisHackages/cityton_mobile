class ChallengeAdmin {
  final int id;
  final String statement;
  final String title;
  final DateTime createdAt;
  final double succesRate;


  ChallengeAdmin({this.id, this.statement, this.title, this.createdAt, this.succesRate});

  factory ChallengeAdmin.fromJson(Map<String, dynamic> json) {
    return ChallengeAdmin(
      id: json['id'] as int,
      statement: json['statement'] as String,
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
      succesRate: json['succesRate'] as double,
    );
  }
}

class ChallengeAdminList {
  final List<ChallengeAdmin> challenges;

  ChallengeAdminList({this.challenges});

  factory ChallengeAdminList.fromJson(List<dynamic> parsedJson) {

    List<ChallengeAdmin> challenges = List<ChallengeAdmin>();
    challenges = parsedJson.map((i) => ChallengeAdmin.fromJson(i)).toList();

    return ChallengeAdminList(
       challenges: challenges,
    );
  }
}
