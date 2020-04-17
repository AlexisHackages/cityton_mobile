import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/user.dart';

var http = Http();

class UserService {

  Future<ApiResponse> getCurrentUser() async {
    var res = await http.get("authentication");

    return res;
  }

  Future<ApiResponse> changePassword(oldPassword, newPassword) async {
    var res = await http.post("user/changePassword",
    {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    return res;
  }
  
}