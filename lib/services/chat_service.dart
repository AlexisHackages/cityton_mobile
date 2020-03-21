import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/thread.dart';

var http = Http();

class ChatService {

  Future<List<Thread>> getThreads() async {

    final res = await http.get("http://10.0.2.2:5000/api/chat/getThreads");

    if (res.statusCode == 200) {
      print(res.data);
      return List<Thread>();
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}