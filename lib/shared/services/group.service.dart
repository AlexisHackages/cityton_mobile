import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class GroupService {

  Future<ApiResponse> getProgression(int threadId) async {

    final res = await http.get("group/getProgression/" + threadId.toString());

    return res;
  }
  
}