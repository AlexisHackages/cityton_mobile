import 'dart:convert';
import 'dart:io';
import 'package:cityton_mobile/components/DisplaySnackbar.dart';
import 'package:cityton_mobile/http/ApiResponse.dart';
import 'package:cityton_mobile/models/user.dart';
import 'package:cityton_mobile/models/userProfile.dart';
import 'package:cityton_mobile/shared/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ProfileBloc {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<User> getCurrentUser() async {
    String encodedCurrentUser = await _storage.read(key: "currentUser");
    return User.fromJson(jsonDecode(encodedCurrentUser));
  }

  Future<UserProfile> getProfile(int userId) async {
    var response = await _userService.getProfile(userId);

    if (response.status != 200) {
      DisplaySnackbar.createError(message: response.value);
      Get.offNamedUntil('/door', (Route<dynamic> route) => false);
      return null;
    }
    return UserProfile.fromJson(response.value);
  }

  Future<ApiResponse> changePicture(File newProfilePicture) async {
    var response = await _userService.changePictureProfile(newProfilePicture);
    return response;
  }
}
