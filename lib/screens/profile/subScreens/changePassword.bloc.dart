import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';

class ChangePasswordBloc {
  final UserService _userService = UserService();

  Future<ApiResponse> changePassword(
      String oldPassword, String newPassword) async {
    var response = await _userService.changePassword(
        oldPassword.trim(), newPassword.trim());
    return response;
  }

}
