import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/SendMessage.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:cityton_mobile/shared/blocs/auth.bloc.dart';
import 'package:cityton_mobile/shared/services/chat.service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ChatBloc {
  final ChatService _chatService = ChatService();
  static final _authBloc = AuthBloc();

  final _messagesFetcher =
      BehaviorSubject<List<Message>>.seeded(List<Message>());
  Stream<List<Message>> get messages => _messagesFetcher.stream;

  HubConnection _hubConnection;
  final httpOptions = new HttpConnectionOptions(
      accessTokenFactory: () async => await _authBloc.getToken(),
      transport: HttpTransportType.WebSockets);

  ChatBloc() {
    buildConnection();
    openChatConnection();
  }

  getMessages(int discussionId) async {
    ApiResponse response = await _chatService.getMessages(discussionId);

    if (response.status == 200) {
      MessageList messageList = MessageList.fromJson(response.value);
      _messagesFetcher.sink.add(messageList.messages);
    }
  }

  closeMessages() {
    _messagesFetcher.close();
  }

  buildConnection() {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:5000/hub/chatHub', options: httpOptions)
        .build();
  }

  Future<void> openChatConnection() async {
    _hubConnection
        .start()
        .catchError((onError) => {print(onError)})
        .then((onValue) => {
              _hubConnection.invoke("AddToGroup").then((onValue) => {
                    _hubConnection.on(
                        "messageReceived", _handleIncommingChatMessage),
                    _hubConnection.on(
                        "messageRemoved", _handleRemovedChatMessage),
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

    int index = messages
        .indexWhere((Message message) => message.id == removedMessage.id);
    messages.replaceRange(index, index + 1, [removedMessage]);

    _messagesFetcher.sink.add(messages);
  }

  Future<void> sendChatMessage(
      String newMessage, int discussionId, File file) async {
    CloudinaryResponse response;

    if (file != null) {
      response = await _chatService.sendToCloudinary(file);
    }

    SendMessage messageToSend =
        SendMessage(newMessage, discussionId, response?.secureUrl);
    await _hubConnection
        .invoke("newMessage", args: <SendMessage>[messageToSend]);
  }

  Future<void> removeMessage(int messageId) async {
    await _hubConnection.invoke("RemoveMessage", args: <Object>[messageId]);
  }

  void closeChatConnection() {
    _hubConnection.stop();
  }
}
