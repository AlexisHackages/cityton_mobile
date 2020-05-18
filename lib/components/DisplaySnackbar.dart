import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DisplaySnackbar {

  static void createError(
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 10)}) {
    return Get.snackbar(
      title,
      message,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red[300],
      ),
      leftBarIndicatorColor: Colors.red[300],
      duration: duration);
  }

  static void createConfirmation(
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 10)}) {
    return Get.snackbar(
      title,
      message,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.green[300],
      ),
      leftBarIndicatorColor: Colors.green[300],
      duration: duration,
    );
  }
}
