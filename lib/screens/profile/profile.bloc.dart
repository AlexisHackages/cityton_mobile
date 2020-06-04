import 'dart:convert';
import 'dart:io';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileBloc {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await _storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<ApiResponse> getProfile(int userId) async {
    var response = await _userService.getProfile(userId);
    return response;
  }

  Future<ApiResponse> changePicture(File newProfilePicture) async {
    var response = await _userService.changePictureProfile(newProfilePicture);
    return response;
  }

}
