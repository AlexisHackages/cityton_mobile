import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class ChallengeService {
  Future<ApiResponse> search(String search, DateTime date) async {
    var res = await http.get("challenge/search", {
      "searchText": search,
      "date": date,
    });

    return res;
  }

  Future<ApiResponse> add(String title, String statement) async {
    var res = await http.post("challenge/add",
    {
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> edit(int id, String title, String statement) async {
    var res = await http.post("challenge/edit",
    {
      "challengeId": id,
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await http.delete("challenge/delete/" + id.toString());

    return res;
  }
}
