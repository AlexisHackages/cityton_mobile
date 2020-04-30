class Thread {
  final int discussionId;
  final String name;

  Thread({this.discussionId, this.name});

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      discussionId: json['discussionId'] as int,
      name: json['name'] as String,
    );
  }
}

class ThreadList {
  final List<Thread> threads;

  ThreadList({this.threads});

  factory ThreadList.fromJson(List<dynamic> parsedJson) {

    List<Thread> threads = new List<Thread>();
    threads = parsedJson.map((i) => Thread.fromJson(i)).toList();

    return new ThreadList(
       threads: threads,
    );
  }
}