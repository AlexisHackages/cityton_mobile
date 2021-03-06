import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/http/http.dart';
import 'package:dio/dio.dart';

var _http = Http();

class AuthService {
  Future<ApiResponse> login(String email, String password) async {
    var res = await _http.post("authentication/login",
        data: {"email": email, "password": password});

    return res;
  }

  Future<ApiResponse> signup(String username, String email, String password,
      File profilePicture) async {
    MultipartFile pictureToSend;

    if (profilePicture != null) {
      String fileName = profilePicture.path.split('/').last;
      pictureToSend =
          await MultipartFile.fromFile(profilePicture.path, filename: fileName);
    }

    FormData formdata = new FormData.fromMap({
      "username": username,
      "email": email,
      "password": password,
      "profilePicture": pictureToSend
    });

    var res = await _http.post("authentication/signup", data: formdata,
        onSendProgress: (int sent, int total) {
      print((sent / total * 100).toString() + "%");
    });

    return res;
  }
}
