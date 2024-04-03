import 'package:color_log/color_log.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/screens/walkthrough/introduction.dart';

class AuthRepository extends GetxController {
  static AuthRepository get to => Get.find();

  final box = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    _screenRedirect();
  }

  void _screenRedirect() {
    box.writeIfNull('isFirstTime', true);

    final bool isFirstTime = box.read('isFirstTime');
    if (isFirstTime) {
      Get.offAll(() => Introduction());
      return;
    }

    final Map<String, dynamic>? authCache = box.read('auth');
    clog.info('authCache: $authCache');
    if (authCache == null) {
      Get.offAll(() => GetStarted());
      return;
    }

    final Map<String, dynamic>? personalization = authCache?['personalization'];
    if (personalization == null) {
      Get.offAll(() => GenderPersonalization());
      return;
    }

    Get.offAll(() => Home());
  }
}
