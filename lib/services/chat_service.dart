import 'dart:convert';
import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/thread.dart';
import 'package:cityton_mobile/models/threadsList.dart';
import 'package:http/http.dart';

var http = Http();

class ChatService {

  Future<List<Thread>> getThreads() async {

    final res = await http.get("http://10.0.2.2:5000/api/chat/getThreads");
    
    if (res.statusCode == 200) {
      // List<Thread> threads = res.data.map<Thread>((Map thread) => Thread.fromJson(thread)).toList();
      ThreadsList threadsList = ThreadsList.fromJson(res.data);
      return threadsList.threads;
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}