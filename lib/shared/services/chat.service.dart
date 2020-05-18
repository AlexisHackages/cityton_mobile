import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
var http = Http();

class ChatService {

  Future<ApiResponse> getThreads(int userId) async {

    final res = await http.get("chat/getThreadsByUserId/" + userId.toString());

    return res;
  }

  Future<ApiResponse> getMessages(int threadId) async {

    final res = await http.get("chat/getMessages/" + threadId.toString());

    return res;
  }
  
}