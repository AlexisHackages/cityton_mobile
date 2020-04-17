import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/models/threadsList.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:cityton_mobile/models/messagesList.dart';

var http = Http();

class ChatService {

  Future<List<Thread>> getThreads() async {

    final res = await http.get("chat/getThreads");

    return List<Thread>();
    
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