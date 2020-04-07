import 'package:cityton_mobile/http/http.dart';
import 'package:cityton_mobile/models/user.dart';

var http = Http();

class UserService {

  Future<User> getCurrentUser() async {
    
    var res = await http.get("http://10.0.2.2:5000/api/authenticate");

    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}