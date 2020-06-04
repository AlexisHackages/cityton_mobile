import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/auth.service.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cityton_mobile/models/user.dart';
import 'dart:convert';

class AuthBloc {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final _tokenFetcher = BehaviorSubject<String>.seeded(null);
  Stream<String> get token => _tokenFetcher.stream;

  AuthBloc();

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<ApiResponse> login(String email, String password) async {
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    var response = await authService.login(sanitizedEmail, sanitizedPassword);

    if (response.status == 200) {
      User currentUser = User.fromJson(response.value);

      await storage.write(key: "token", value: currentUser.token);

      _tokenFetcher.sink.add(currentUser.token);

      await storage.write(
          key: "currentUser", value: jsonEncode(currentUser));
    }

    return response;
  }

  Future<ApiResponse> signup(
      String username, String email, String password, File profilePicture) async {
    String sanitizedUsername = username.trim();
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    var response = await authService.signup(
        sanitizedUsername, sanitizedEmail, sanitizedPassword, profilePicture);

    if (response.status == 200) {
      User currentUser = User.fromJson(response.value);
      await storage.write(key: "token", value: currentUser.token);

      _tokenFetcher.sink.add(currentUser.token);

      await storage.write(
          key: "currentUser", value: jsonEncode(currentUser));
    }

    return response;
  }

  void logout() {
    storage.delete(key: "token");
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  void closeTokenStream() {
    _tokenFetcher.close();
  }
}
