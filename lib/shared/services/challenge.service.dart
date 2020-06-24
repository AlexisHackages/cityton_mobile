import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var _http = Http();

class ChallengeService {
  Future<ApiResponse> searchAdmin(String search, DateTime date) async {
    var res = await _http.get("challenge/searchAdmin", {
      "searchText": search,
      "date": date,
    });

    return res;
  }

  Future<ApiResponse> searchProgression(String search, int threadId) async {
    var res = await _http.get("challenge/searchProgression", {
      "searchText": search,
      "threadId": threadId,
    });

    return res;
  }

  Future<ApiResponse> add(String title, String statement) async {
    var res = await _http.post("challenge/add",
    data: {
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> edit(int id, String title, String statement) async {
    var res = await _http.post("challenge/edit",
    data: {
      "challengeId": id,
      "title": title,
      "statement": statement,
    });

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await _http.put("challenge/delete/" + id.toString());

    return res;
  }

  Future<ApiResponse> validate(int id) async {
    var res = await _http.put("challenge/validate/" + id.toString());

    return res;
  }

  Future<ApiResponse> reject(int id) async {
    var res = await _http.put("challenge/reject/" + id.toString());

    return res;
  }

  Future<ApiResponse> undo(int id) async {
    var res = await _http.put("challenge/undo/" + id.toString());

    return res;
  }

  Future<ApiResponse> attributeToGroup(int threadId, List<int> selectedChallenges) async {
    var res = await _http.post("challenge/attributeToGroup/", data: {
      "threadId": threadId,
      'challengeIds': selectedChallenges
    });

    return res;
  }
}
