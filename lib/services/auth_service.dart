import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {

  Future<String> login(String email, String password) async {

    // var res = await http.get("http://10.0.2.2:5000/api/user/existEmail/"+email);
    var res = await http.post("http://10.0.2.2:5000/api/authenticate/login",
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: json.encode({"email": email, "password": password}));

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception(res.statusCode);
    }
    
  }
  
}

// login(email: string, password: string): Observable<string> {
//     return this.http.post<string>(environment.apiUrl + 'authenticate/login', { email, password })
//       .pipe(map((data: any) => {
//         let token = data.token;

//         if (token) {
//           localStorage.setItem('currentToken', token);
//           this.currentToken.next(token);
//         }

//         return token;
//       })

//       )
//   }
