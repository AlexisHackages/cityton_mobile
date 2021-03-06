import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';

class UserInfoBloc {
  final UserService _userService = UserService();
  
  Future<ApiResponse> delete(int id) async {

    var response = await _userService.delete(id);

    return response;
  }

  Future<ApiResponse> changeRole(int userId, int selectedRole) async {

    var response = await _userService.changeRole(userId, selectedRole);

    return response;
  }
}
