import 'package:cityton_mobile/services/chat_service.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {

  final ChatService chatService = ChatService();

  final _messagesFetcher = BehaviorSubject<List<Message>>.seeded(List<Mesage>());
  Stream<List<Message>> get threads => _messagesFetcher.stream;

  ChatBloc();

  getMessages(int discussionId) async {
    List<Message> messages = await chatService.getMessages(discussionId);
    // _threadsFetcher.add(threads);
    _messagesFetcher.sink.add(messages);
  }

  closeThreads() {
    _messagesFetcher.close();
  }

}