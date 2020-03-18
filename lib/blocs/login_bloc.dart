import 'dart:convert';

import 'package:cityton_mobile/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginBloc {

  AuthService authService;

  LoginBloc() {
    this.authService = new AuthService();
  }

  final storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    storage.deleteAll();
    Map<String, dynamic> token = json.decode(await authService.login(email, password));

    storage.write(key: "token", value: token['token']);

    return true;
    
  }

}