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
    data: {
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> edit(int id, String title, String statement) async {
    var res = await http.post("challenge/edit",
    data: {
      "challengeId": id,
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await http.put("challenge/delete/" + id.toString());

    return res;
  }

  Future<ApiResponse> validate(int id) async {
    var res = await http.put("challenge/validate/" + id.toString());

    return res;
  }

  Future<ApiResponse> reject(int id) async {
    var res = await http.put("challenge/reject/" + id.toString());

    return res;
  }

  Future<ApiResponse> undo(int id) async {
    var res = await http.put("challenge/undo/" + id.toString());

    return res;
  }
}
