import 'dart:convert';
import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileBloc {
  final UserService userService = UserService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<ApiResponse> changePassword(
      String oldPassword, String newPassword) async {
    var response = await userService.changePassword(
        oldPassword.trim(), newPassword.trim());
    return response;
  }

  Future<ApiResponse> getProfile(int userId) async {
    var response = await userService.getProfile(userId);
    return response;
  }

  Future<ApiResponse> changePicture(File newProfilePicture) async {
    var response = await userService.changePictureProfile(newProfilePicture);
    return response;
  }

}
