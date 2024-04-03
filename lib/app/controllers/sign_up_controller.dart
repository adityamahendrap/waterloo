import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

class SignUpController extends GetxController {
  final authC = Get.find<AuthController>();
  final signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isAgree = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void signUp(SignUpValidator validator) async {
    if (!validator.isValid()) {
      AppSnackBar.error("Failed",
          "Please fill the form correctly and agree terms & conditions");
      return;
    }
    try {
      final UserCredential credential = await AuthService.signUpWithEmail(
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

class SignUpValidator {
  final signUpC = Get.find<SignUpController>();

  bool isValid() {
    return email(signUpC.emailController.text) == null &&
        password(signUpC.passwordController.text) == null &&
        confirmPassword(signUpC.confirmPasswordController.text) == null &&
        signUpC.isAgree.value;
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

  String? confirmPassword(String? value) {
    if (value!.isEmpty) {
      return 'This field must be filled';
    }
    if (value != signUpC.passwordController.text) {
      return 'Password does not match';
    }
    return null;
  }

  String? password(String? value) {
    if (value!.isEmpty) {
      return 'This field must be filled';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
