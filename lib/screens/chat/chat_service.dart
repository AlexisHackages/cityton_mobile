import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/message.dart';

var http = Http();

class ChatService {

  Future<ApiResponse> getThreads(int userId) async {

    final res = await http.get("chat/getThreadsByUserId/" + userId.toString());

    return res;
    
    // if (res.statusCode == 200) {
    //   // List<Thread> threads = res.data.map<Thread>((Map thread) => Thread.fromJson(thread)).toList();
    //   ThreadsList threadsList = ThreadsList.fromJson(res.data);
    //   return threadsList.threads;
    // } else {
    //   throw Exception(res.statusCode);
    // }
    
  }

  Future<List<Message>> getMessages(int threadId) async {

    final res = await http.get("chat/getMessages/" + threadId.toString());

    return List<Message>();

    // if (res.statusCode == 200) {
    //   MessagesList messagesList = MessagesList.fromJson(res.data);
    //   return messagesList.messages;
    // } else {
    //   throw Exception(res.statusCode);
    // }
    
  }
  
}