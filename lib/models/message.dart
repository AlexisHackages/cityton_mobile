import 'package:cityton_mobile/models/user_minimal.dart';
import 'package:cityton_mobile/models/media_minimal.dart';

class Message {
  final int id;
  final String content;
  final MediaMinimal media;
  final UserMinimal author;
  final DateTime createdAt;
  final int discussionId;

  Message({this.id, this.content, this.media, this.author, this.createdAt, this.discussionId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      content: json['content'] == null ? "Has been removed" : json['content'] as String,
      media: json['media'] == null ? null : MediaMinimal.fromJson(json['media']),
      author: UserMinimal.fromJson(json['author']),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      discussionId: json['discussionId'] as int,
    );
  }
}

class MessageList {
  final List<Message> messages;

  MessageList({this.messages});

  factory MessageList.fromJson(List<dynamic> parsedJson) {

    List<Message> messages = new List<Message>();
    messages = parsedJson.map((i) => Message.fromJson(i)).toList();

    return MessageList(
       messages: messages,
    );
  }
}

