import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

class SignInController extends GetxController {
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

  void firebaseEmailSignIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (credential.user != null) {
        AppSnackBar.success("Success", "Sign up success");
        Get.offAll(Home());
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      AppSnackBar.error("Failed", e.message!);
    } catch (e) {
      AppSnackBar.error("Failed", "Something went wrong");
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
