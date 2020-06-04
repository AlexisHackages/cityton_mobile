import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';

class UserInfoBloc {
  final UserService userService = UserService();
  
  Future<ApiResponse> delete(int id) async {

    var response = await userService.delete(id);

    return response;
  }
}
