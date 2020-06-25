import 'package:json_annotation/json_annotation.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  final int discussionId;
  final String name;

  Thread(this.discussionId, this.name);

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadToJson(this);
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
