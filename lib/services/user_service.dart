import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var http = Http();

class UserService {

  Future<User> getCurrentUser() async {
    
    var res = await http.get(DotEnv().env['API_URL'] + "authenticate");

    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}