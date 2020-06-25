import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/shared/services/auth.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cityton_mobile/models/user.dart';
import 'dart:convert';

class AuthBloc {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final _tokenFetcher = BehaviorSubject<String>.seeded(null);
  Stream<String> get token => _tokenFetcher.stream;

  AuthBloc();

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await _storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<ApiResponse> login(String email, String password) async {
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    var response = await _authService.login(sanitizedEmail, sanitizedPassword);

    if (response.status == 200) {
      User currentUser = User.fromJson(response.value);
      await writeCurrentUser(currentUser);
    }

    return response;
  }

  Future<ApiResponse> signup(String username, String email, String password,
      File profilePicture) async {
    String sanitizedUsername = username.trim();
    String sanitizedEmail = email.trim();
    String sanitizedPassword = password.trim();

    var response = await _authService.signup(
        sanitizedUsername, sanitizedEmail, sanitizedPassword, profilePicture);

    if (response.status == 200) {
      User currentUser = User.fromJson(response.value);
      writeCurrentUser(currentUser);
    }

    return response;
  }

  void logout() {
    _storage.delete(key: "token");
  }

  Future<String> getToken() async {
    return await _storage.read(key: "token");
  }

  void closeTokenStream() {
    _tokenFetcher.close();
  }

  Future<void> writeCurrentUser(User currentUser) async {
    await _storage.write(key: "token", value: currentUser.token);

    _tokenFetcher.sink.add(currentUser.token);

    await _storage.write(key: "currentUser", value: json.encode(currentUser));
  }

  Future<void> deleteCurrentUser() async {
    await _tokenFetcher.drain();
    await _storage.delete(key: "token");
    await _storage.delete(key: "currentUser");
  }
}
