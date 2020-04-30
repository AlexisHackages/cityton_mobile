import 'package:cityton_mobile/models/message.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/shared/services/chat.service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_client/signalr_client.dart';

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
      .withUrl(DotEnv().env['API_URL'] + 'hub/chathub', options: httpOptions)
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
