import 'package:rxdart/rxdart.dart';
import 'package:cityton_mobile/services/auth_service.dart';

class LoginBloc {

  AuthService authService;

  LoginBloc() {
  }

  String login(String email, String password) {
    String result;

    authService.login(email, password)
      .then((value) => {
        result = value
        });

    print(result);
    
    return result;
  }

}