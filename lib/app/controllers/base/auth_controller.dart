import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/screens/walkthrough/introduction.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

// !! https://firebase.flutter.dev/docs/auth/social
class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final box = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    _afterSplashScreenRedirect();
  }

  void _afterSplashScreenRedirect() {
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

    final Map<String, dynamic>? personalization = authCache['personalization'];
    if (personalization == null) {
      Get.offAll(() => GenderPersonalization());
      return;
    }

    Get.offAll(() => Home());
  }

  void google() async {
    try {
      final UserCredential credential = await AuthService.signInWithGoogle();
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }

  void facebook() async {
    try {
      final UserCredential credential = await AuthService.signInWithFacebook();
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }

  void github(BuildContext context) async {
    try {
      final UserCredential credential =
          await AuthService.signInWithGitHub(context);
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    clog.info('user logged out');
    box.remove('auth');
    clog.info('cache cleared');
    Get.offAll(() => GetStarted());
  }

  void cacheUser(Map<String, dynamic> user) {
    clog.debug("try to cache user");
    box.write('auth', user);
    clog.info('user cached: $user');
  }

  void afterSignRedirect(Map<String, dynamic> user) {
    if (user['personalization'] == null) {
      clog.info('personalization not set yet');
      Get.offAll(() => GenderPersonalization());
      return;
    }

    clog.info('redirecting to home');
    Get.offAll(() => Home());
  }

  void _handleErr(dynamic e) {
    AppSnackBar.error("Failed",
        e is FirebaseAuthException ? e.message! : "Unknown error occurred");
  }
}
