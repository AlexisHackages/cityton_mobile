import 'package:cityton_mobile/http/http.dart';

var http = Http();

class AuthService {

  Future<String> login(String email, String password) async {
    
    var res = await http.post("http://10.0.2.2:5000/api/authenticate/login",
      {"email": email, "password": password});

    if (res.statusCode == 200) {
      return res.data["token"];
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}