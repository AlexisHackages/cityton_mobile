import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/user.dart';

var http = Http();

class AuthService {

  Future<User> login(String email, String password) async {
    
    var res = await http.post("authentication/login",
      {"email": email, "password": password});
      
    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(res.statusCode);
    }
    
  }

  Future<User> signup(String username, String email, String password, String picture) async {
    var res = await http.post("authentication/signup",
      {"username": username, "email": email, "password": password, "picture": picture});
      
    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}