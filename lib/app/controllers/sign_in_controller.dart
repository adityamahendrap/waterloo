import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

class SignInController extends GetxController {
  final authC = Get.find<AuthController>();
  final signInFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isRememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void signIn(SignInValidator validator) async {
    if (!validator.isValid()) {
      AppSnackBar.error("Failed", "Please fill the form correctly");
      return;
    }

    try {
      final UserCredential credential = await AuthService.signInWithEmail(
          emailController.text, passwordController.text);

      final user = await AuthService.checkOrCreateUser(credential);
      authC.cacheUser(user);
      authC.afterSignRedirect(user);
    } on FirebaseAuthException catch (e) {
      print(e);
      AppSnackBar.error("Failed", e.message!);
    } catch (e) {
      AppSnackBar.error("Failed", "Unknown Error");
      print(e);
    }
  }
}

class SignInValidator {
  final signInC = Get.find<SignInController>();

  bool isValid() {
    return email(signInC.emailController.text) == null &&
        password(signInC.passwordController.text) == null;
  }

  String? email(String? value) {
    if (value!.isEmpty) {
      return 'This field must be filled';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? password(String? value) {
    if (value!.isEmpty) {
      return 'This field must be filled';
    }
    return null;
  }
}
