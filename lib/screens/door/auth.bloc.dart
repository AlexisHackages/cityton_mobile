import 'package:cityton_mobile/services/auth_service.dart';
import 'package:cityton_mobile/services/user_service.dart';
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

  Future<bool> login(String email, String password) async {
    // await storage.deleteAll();
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    String token = await authService.login(sanitizedEmail, sanitizedPassword);
    await storage.write(key: "token", value: token);

    _tokenFetcher.sink.add(token);

    User currentUser = await userService.getCurrentUser();
    await storage.write(key: "currentUser", value: jsonEncode(currentUser.toJson()));

    return true;
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