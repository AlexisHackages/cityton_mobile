import 'package:http/http.dart' as http;

class AuthService {

  Future<String> login(String email, String password) async {
    var res = http.post("http://localhost:5000/api/authenticate/login",
        body: {"email": email, "password": password});
    print(res);
    // if(res.StatusCode == 200) return res.body;
    return null;
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
