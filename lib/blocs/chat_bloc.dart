import 'package:cityton_mobile/services/chat_service.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {

  final ChatService chatService = ChatService();

  final _messagesFetcher = BehaviorSubject<List<Message>>.seeded(List<Message>());
  Stream<List<Message>> get messages => _messagesFetcher.stream;

  ChatBloc();

  getMessages(int discussionId) async {
    List<Message> messages = await chatService.getMessages(discussionId);
    _messagesFetcher.sink.add(messages);
  }

  closeMessages() {
    _messagesFetcher.close();
  }

}