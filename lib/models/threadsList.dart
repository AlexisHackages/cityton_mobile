import 'package:cityton_mobile/models/thread.dart';

class ThreadsList {
  final List<Thread> threads;

  ThreadsList({this.threads});

  factory ThreadsList.fromJson(List<dynamic> parsedJson) {

    List<Thread> threads = new List<Thread>();
    threads = parsedJson.map((i) => Thread.fromJson(i)).toList();

    return new ThreadsList(
       threads: threads,
    );
  }
}
