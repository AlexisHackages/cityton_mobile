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
      // _hubConnection.start();
      // _hubConnection.onclose((error) => print("IS CLOSED"));
      // _hubConnection.on("ReceiveMessage", _handleIncommingChatMessage);

      // await _hubConnection.invoke("AddToGroup");

    // print("_hubConnection = ");
    // print(_hubConnection);

    // if (_hubConnection == null) {
    //   _hubConnection = HubConnectionBuilder().withUrl("http://10.0.2.2:5000/hub/chathub").build();
    //   print("VVVVV");
    //     // _hubConnection.invoke("AddToGroup"),
    //   _hubConnection.on("messageReceived", (message) { print(message); });
    //   print("WWWWW");
    // }

    // if (_hubConnection.state != HubConnectionState.Connected) {
    //   _hubConnection.start();
    // }
    
    // _hubConnection = HubConnectionBuilder()
    //     .withUrl("http://10.0.2.2:5000/hub/chathub")
    //     .build();
    
    // print("JOJO");

    _hubConnection.start()
      .then((onValue)
        => {
          _hubConnection.invoke("AddToGroup")
            .then((onValue) => {
              _hubConnection.on("messageReceived", _handleIncommingChatMessage)
            })
        });
    

    
    
    // _hubConnection.start()
    //   .then((value) async => {
    //     print("TOTO"),
    //     await _hubConnection.invoke("AddToGroup")
    //       .then((onValue) async => {
    //         _hubConnection.on("messageReceived", (message) { print(message); }),
    //         print("DODO"),
    //       })
    //       .catchError((Error error) {print("XAXA"); print(error);}),
    //     }
    //   )
    //   .catchError((Error problem) {print("WAWA"); print(problem);});
    // print("LOL");
    
  }

  void _handleIncommingChatMessage(List<Object> newMessage) {
    List<Message> messages = _messagesFetcher.value;
    messages.add(Message.fromJson(newMessage[0]));
    _messagesFetcher.sink.add(messages);
  }

  Future<void> sendChatMessage(String newMessage, int discussionId, String imageUrl) async {
    _hubConnection.invoke("newMessage", args: <Object>[newMessage, discussionId, imageUrl] );
  }

  void closeChatConnection() {
    print("CLOSE");
    _hubConnection.stop();
  }
}
