import 'package:cityton_mobile/services/chat_service.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_client/signalr_client.dart';

class ChatBloc {

  final ChatService chatService = ChatService();

  final _messagesFetcher = BehaviorSubject<List<Message>>.seeded(List<Message>());
  Stream<List<Message>> get messages => _messagesFetcher.stream;

  HubConnection _hubConnection;

  ChatBloc() {
    openChatConnection();
  }

  getMessages(int discussionId) async {
    List<Message> messages = await chatService.getMessages(discussionId);
    _messagesFetcher.sink.add(messages);
  }

  closeMessages() {
    _messagesFetcher.close();
  }

  Future<void> openChatConnection() async {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder().withUrl("http://10.0.2.2:5000/hub/chathub").build();
      _hubConnection.on("messageReceived", _handleIncommingChatMessage);
    }

    if (_hubConnection.state != HubConnectionState.Connected) {
      await _hubConnection.start();
    }
  }

  void _handleIncommingChatMessage(Message newMessage){
    List<Message> messages = _messagesFetcher.value;
    messages.add(newMessage);
    _messagesFetcher.sink.add(messages);
  }

}