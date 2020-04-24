import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class ChallengeService {
  Future<ApiResponse> search(String search, DateTime date) async {
    String lol = "a";
    var res = await http.get("challenge/search", {
      "searchText": search,
      "date": date,
    });

    return res;
  }
}
