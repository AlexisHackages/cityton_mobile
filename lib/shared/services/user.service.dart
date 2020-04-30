import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class UserService {

  Future<ApiResponse> getCurrentUser() async {
    var res = await http.get("authentication");

    return res;
  }

  Future<ApiResponse> changePassword(String oldPassword, String newPassword) async {
    var res = await http.post("user/changePassword",
    {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    return res;
  }

  Future<ApiResponse> getProfile(int userId) async {
    var res = await http.get("user/getProfile/" + userId.toString());

    return res;
  }

  Future<ApiResponse> search(String search, int selectedRole) async {
    var res = await http.get("user/search", {
      "searchText": search,
      "selectedRole": selectedRole,
    });

    return res;
  }

  Future<ApiResponse> delete(int id) async {
    var res = await http.delete("user/delete/" + id.toString());

    return res;
  }
  
}