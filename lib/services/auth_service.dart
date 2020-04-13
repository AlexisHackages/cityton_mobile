import 'package:cityton_mobile/http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var http = Http();

class AuthService {

  Future<String> login(String email, String password) async {
    
    var res = await http.post(DotEnv().env['API_URL'] + "authenticate/login",
      {"email": email, "password": password});

    if (res.statusCode == 200) {
      return res.data["token"];
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}