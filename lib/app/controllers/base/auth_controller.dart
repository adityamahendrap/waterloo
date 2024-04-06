import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/forgot_password/new_password.dart';
import 'package:waterloo/app/screens/forgot_password/success.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/screens/walkthrough/introduction.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:waterloo/app/utils/app_snack_bar.dart';
import 'package:waterloo/app/utils/go_go_exception.dart';
import 'package:waterloo/app/widgets/loading.dart';

// !! https://firebase.flutter.dev/docs/auth/social
class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final box = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    clog.debug('userCache when app started: ${box.read('auth')}');
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
    EasyLoading.show();
    try {
      final UserCredential credential = await AuthService.signInWithGoogle();
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void facebook() async {
    EasyLoading.show();
    try {
      final UserCredential credential = await AuthService.signInWithFacebook();
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void github(BuildContext context) async {
    try {
      final UserCredential credential =
          await AuthService.signInWithGitHub(context);
      EasyLoading.show();
      final user = await AuthService.checkOrCreateUser(credential);
      cacheUser(user);
      afterSignRedirect(user);
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
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
    switch (e.runtimeType) {
      case FirebaseAuthException:
        clog.error(e.toString());
        AppSnackBar.error('Failed', e.message!);
        break;
      case GoGoException:
        clog.error((e as GoGoException).message.toString());
        AppSnackBar.error('Failed', e.message);
        break;
      default:
        clog.error(e.toString());
        AppSnackBar.error('Failed', 'Unknown error occurred');
    }
  }

  Future<void> sendOTPCode(String email) async {
    if (email.isEmpty) {
      AppSnackBar.error('Failed', 'Please fill the email field');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppSnackBar.error('Failed', 'Invalid email format');
      return;
    }

    EasyLoading.show();
    try {
      await AuthService.forgotPasswordAccountCheck(email);
      final otpCode = await AuthService.generateAndSaveOTPCode(email);
      await AuthService.sendOTPCodeWithEmail(email, otpCode);
      Get.off(() => EnterOtpCode(), arguments: {'email': email});
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> resendOTPCode(String email) async {
    EasyLoading.show();
    try {
      await AuthService.deletePreviousOTPCode(email);
      final otpCode = await AuthService.generateAndSaveOTPCode(email);
      await AuthService.sendOTPCodeWithEmail(email, otpCode);
      AppSnackBar.success('Success', 'OTP code has been resent');
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> verifyOTPCode(String email, String otpCode) async {
    EasyLoading.show();
    try {
      await AuthService.verifyOTPCode(email, otpCode);
      Get.off(() => NewPassword(), arguments: {'email': email});
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updatePassword(String email, String password, String newPassword) async {
    if (password != newPassword) {
      AppSnackBar.error('Failed', 'Passwords do not match');
      return;
    }
    if (password.length < 6) {
      AppSnackBar.error('Failed', 'Password must be at least 6 characters');
      return;
    }

    EasyLoading.show();
    try {
      // TODO
      // await AuthService.updatePassword(email, password);
      Get.offAll(() => Success());
    } catch (e) {
      _handleErr(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
