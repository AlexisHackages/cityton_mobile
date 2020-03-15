import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:cityton_mobile/services/auth_service.dart';
import 'package:http/http.dart' as http;

class LoginBloc {

  AuthService authService;

  LoginBloc() {
    this.authService = new AuthService();
  }

  Future<String> login(String email, String password) async {
    String result;

    print("!!!!! LOGIN !!!!!");
    print(email);
    print(password);
    print("!!!!! END LOGIN !!!!!");

    // var test = authService.login(email, password);

    // final res = await http.post("http://192.168.1.14:5000/api/authenticate/login",
    final res = await http.get("http://192.168.1.14:5000/api/user/existEmail/admin01@gmail.com");
      print(res.body);
    return res.body;

    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

}