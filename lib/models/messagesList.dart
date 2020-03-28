import 'package:cityton_mobile/models/message.dart';

class MessagesList {
  final List<Message> messages;

  MessagesList({this.messages});

  factory MessagesList.fromJson(List<dynamic> parsedJson) {

    List<Message> messages = new List<Message>();
    messages = parsedJson.map((i) => Message.fromJson(i)).toList();

    return new MessagesList(
       messages: messages,
    );
  }
}
