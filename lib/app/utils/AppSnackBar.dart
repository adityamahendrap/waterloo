import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static SnackbarController error(String title, dynamic message) {
    clog.error(message);
    return Get.snackbar(
      title,
      message.toString(),
      backgroundGradient: LinearGradient(
        colors: [Colors.red, Colors.orange],
      ),
    );
  }

  static SnackbarController success(String title, dynamic message) {
    clog.info(message);
    return Get.snackbar(
      title,
      message.toString(),
      backgroundGradient: LinearGradient(
        colors: [Colors.blue, Colors.lightBlue],
      ),
    );
  }
}
