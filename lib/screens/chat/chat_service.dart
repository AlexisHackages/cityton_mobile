import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/models/threadsList.dart';
import 'package:cityton_mobile/models/message.dart';
import 'package:cityton_mobile/models/messagesList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var http = Http();

class ChatService {

  Future<List<Thread>> getThreads() async {

    final res = await http.get(DotEnv().env['API_URL'] + "chat/getThreads");
    
    if (res.statusCode == 200) {
      // List<Thread> threads = res.data.map<Thread>((Map thread) => Thread.fromJson(thread)).toList();
      ThreadsList threadsList = ThreadsList.fromJson(res.data);
      return threadsList.threads;
    } else {
      throw Exception(res.statusCode);
    }
    
  }

  Future<List<Message>> getMessages(int threadId) async {

    final res = await http.get(DotEnv().env['API_URL'] + "chat/getMessages/" + threadId.toString());

    if (res.statusCode == 200) {
      MessagesList messagesList = MessagesList.fromJson(res.data);
      return messagesList.messages;
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}