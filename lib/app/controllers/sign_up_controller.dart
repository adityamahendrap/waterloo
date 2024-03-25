import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

class SignUpController extends GetxController {
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

  void firebaseEmailSignUp() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.emailController.text,
        password: this.passwordController.text,
      );

      if (credential.user != null) {
        AppSnackBar.success("Success", "Sign up success");
        Get.offAll(GenderPersonalization());
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

class SignUpValidator {
  final signUpC = Get.find<SignUpController>();

  bool isValid() {
    return email(signUpC.emailController.text) == null &&
        password(signUpC.passwordController.text) == null &&
        confirmPassword(signUpC.confirmPasswordController.text) ==
            null;
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