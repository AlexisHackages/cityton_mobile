import 'dart:convert';

import 'package:cityton_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc {

  final AuthService authService = AuthService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  AuthBloc();

  Future<bool> login(String email, String password) async {
    await storage.deleteAll();
    String token = await authService.login(email, password);
    await storage.write(key: "token", value: token);

    return true;
  }

  void logout() {
    storage.delete(key: "token");
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
    // String token = "";
    // storage.read(key: "token").then(
    //   (String value) => token = value
    // );
    // return token;
  }

}