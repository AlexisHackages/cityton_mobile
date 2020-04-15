import 'package:cityton_mobile/shared/services/auth_service.dart';
import 'package:cityton_mobile/shared/services/user_service.dart';
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

    User currentUser = await authService.login(sanitizedEmail, sanitizedPassword);
    await storage.write(key: "token", value: currentUser.token);

    _tokenFetcher.sink.add(currentUser.token);

    await storage.write(key: "currentUser", value: jsonEncode(currentUser.toJson()));

    return true;
  }

  Future<bool> signup(String username, String email, String password, String picture) async {

    String sanitizedUsername = username.trim();
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    User currentUser = await authService.signup(sanitizedUsername, sanitizedEmail, sanitizedPassword, picture);
    await storage.write(key: "token", value: currentUser.token);

    _tokenFetcher.sink.add(currentUser.token);

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