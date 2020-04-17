import 'dart:convert';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileBloc {

  final UserService userService = UserService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  closeThreads() {
  }

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<ApiResponse> changePassword(String oldPassword, String newPassword) async {
    var response = await userService.changePassword(oldPassword.trim(), newPassword.trim());
    return response;
  }

}