import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';

var http = Http();

class AuthService {

  Future<ApiResponse> login(String email, String password) async {
    
    var res = await http.post("authentication/login",
      {"email": email, "password": password});
      
    return res;
  }

  Future<ApiResponse> signup(String username, String email, String password, String picture) async {
    var res = await http.post("authentication/signup",
      {"username": username, "email": email, "password": password, "picture": picture});
      
    return res;
    
  }
  
}