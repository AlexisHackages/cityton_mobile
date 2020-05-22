import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class GroupService {
  Future<ApiResponse> getProgression(int threadId) async {
    final res = await http.get("group/getProgression/" + threadId.toString());

    return res;
  }

  Future<ApiResponse> search(String searchText, int selectedFilter) async {
    var res =
        await http.get("group/searchGroup", {"groupName": searchText, "selectedFilter": selectedFilter});

    return res;
  }

  Future<ApiResponse> add(String name) async {
    var res = await http.post("group/createGroup", {"name": name});

    return res;
  }

  Future<ApiResponse> getGroupInfo(int groupId) async {
    final res = await http.get("group/getGroupInfo/" + groupId.toString());

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await http.delete("group/deleteGroup/" + id.toString());

    return res;
  }

  Future<ApiResponse> deleteMembership(int id) async {
    var res = await http.delete("group/deleteMembership/" + id.toString());

    return res;
  }

  Future<ApiResponse> deleteRequest(int id) async {
    var res = await http.delete("group/deleteGroupRequest/" + id.toString());

    return res;
  }

  Future<ApiResponse> acceptRequest(int id) async {
    var res = await http.put("group/acceptGroupRequest/" + id.toString());

    return res;
  }

  Future<ApiResponse> editName(String name, int id) async {
    var res = await http
        .put("group/editName/" + id.toString(), {"groupName": name});

    return res;
  }

  Future<ApiResponse> createRequest(int groupId) async {
    var res = await http
        .post("group/createRequest/",
        {
          "GroupId": groupId
        });

    return res;
  }
}
