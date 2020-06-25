import 'package:cityton_mobile/models/mediaMinimal.dart';
import 'package:cityton_mobile/models/userMinimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final String content;
  final MediaMinimal media;
  final UserMinimal author;
  final DateTime createdAt;
  final int discussionId;

  Message(this.id, this.content, this.media, this.author, this.createdAt,
      this.discussionId);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
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
