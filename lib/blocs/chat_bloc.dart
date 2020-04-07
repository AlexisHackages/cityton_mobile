import 'package:cityton_mobile/services/chat_service.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:cityton_mobile/blocs/auth_bloc.dart';

class ChatBloc {
  final ChatService chatService = ChatService();
  static final authBloc = AuthBloc();

  final _messagesFetcher =
      BehaviorSubject<List<Message>>.seeded(List<Message>());
  Stream<List<Message>> get messages => _messagesFetcher.stream;

  HubConnection _hubConnection;
  final httpOptions = new HttpConnectionOptions( accessTokenFactory: () async => await authBloc.getToken(), transport: HttpTransportType.WebSockets);

  ChatBloc() {
    buildConnection();
    openChatConnection();
  }

  getMessages(int discussionId) async {
    List<Message> messages = await chatService.getMessages(discussionId);
    _messagesFetcher.sink.add(messages);
  }

  closeMessages() {
    _messagesFetcher.close();
  }

  buildConnection() {
    _hubConnection = HubConnectionBuilder()
      .withUrl('http://10.0.2.2:5000/hub/chathub', options: httpOptions)
      .build();
  }

  Future<void> openChatConnection() async {

    _hubConnection.start()
      .then((onValue)
        => {
          _hubConnection.invoke("AddToGroup")
            .then((onValue) => {
              _hubConnection.on("messageReceived", _handleIncommingChatMessage),
              _hubConnection.on("messageRemoved", _handleRemovedChatMessage),
            })
        });
    
  }

  void _handleIncommingChatMessage(List<Object> newMessage) {
    List<Message> messages = _messagesFetcher.value;
    messages.add(Message.fromJson(newMessage[0]));
    _messagesFetcher.sink.add(messages);
  }

  void _handleRemovedChatMessage(List<Object> removedMessages) {
    List<Message> messages = _messagesFetcher.value;
    Message removedMessage = Message.fromJson(removedMessages[0]);
    
    
    int index = messages.indexWhere((Message message) => message.id == removedMessage.id);
    messages.replaceRange(index, index + 1, [removedMessage]);
    
    _messagesFetcher.sink.add(messages);
  }

  Future<void> sendChatMessage(String newMessage, int discussionId, String imageUrl) async {
    await _hubConnection.invoke("newMessage", args: <Object>[newMessage, discussionId, imageUrl] );
  }

  Future<void> removeMessage(int messageId) async {
    await _hubConnection.invoke("RemoveMessage", args: <Object>[messageId]);
  }

  void closeChatConnection() {
    print("CLOSE");
    _hubConnection.stop();
  }

}
