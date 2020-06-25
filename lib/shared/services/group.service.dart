import 'dart:convert';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var _http = Http();

class GroupService {
  Future<ApiResponse> getProgression(int threadId) async {
    final res = await _http.get("group/getProgression/" + threadId.toString());

    return res;
  }

  Future<ApiResponse> search(String searchText, int selectedFilter) async {
    var res = await _http.get("group/searchGroup",
        {"groupName": searchText, "selectedFilter": selectedFilter});

    return res;
  }

  Future<ApiResponse> add(String name) async {
    var res = await _http.post("group/createGroup", data: {"name": name});

    return res;
  }

  Future<ApiResponse> getGroupInfo(int groupId) async {
    final res = await _http.get("group/getGroupInfo/" + groupId.toString());

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await _http.delete("group/deleteGroup/" + id.toString());

    return res;
  }

  Future<ApiResponse> deleteMembership(int id) async {
    var res = await _http.delete("group/deleteMembership/" + id.toString());

    return res;
  }

  Future<ApiResponse> deleteRequest(int id) async {
    var res = await _http.delete("group/deleteGroupRequest/" + id.toString());

    return res;
  }

  Future<ApiResponse> acceptRequest(int id) async {
    var res = await _http.put("group/acceptGroupRequest/" + id.toString());

    return res;
  }

  Future<ApiResponse> editName(String name, int id) async {
    var res = await _http.put("group/editName/" + id.toString(), data: jsonEncode(name));

    return res;
  }

  Future<ApiResponse> createRequest(int groupId) async {
    var res =
        await _http.post("group/createRequest/", data: groupId);

    return res;
  }

  Future<ApiResponse> attributeSupervisor(
      int groupId, int selectedUserId) async {
    var res = await _http.put("group/attributeSupervisor/" + groupId.toString(), data: selectedUserId);

    return res;
  }
}
