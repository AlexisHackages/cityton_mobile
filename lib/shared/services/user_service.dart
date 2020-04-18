import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/user.dart';

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
  
}