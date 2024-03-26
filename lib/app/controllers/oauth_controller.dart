import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

// !! https://firebase.flutter.dev/docs/auth/social
class OAuthController  {
  GetStorage box = GetStorage();

  void _redirect(UserCredential credential) {
    credential.additionalUserInfo!.isNewUser
        ? Get.offAll(GenderPersonalization())
        : Get.offAll(Home());
  }

  void _setAuth(UserCredential credential) async {
    box.write('auth', credential);
  }

  void google() async {
    final UserCredential credential = await AuthService.signInWithGoogle();
    print(credential);
    _setAuth(credential);
    _redirect(credential);
  }

  void facebook() async {
    final UserCredential credential = await AuthService.signInWithFacebook();
    print(credential);
    _setAuth(credential);
    _redirect(credential);
  }

  void github(BuildContext context) async {
    final UserCredential credential =
        await AuthService.signInWithGitHub(context);
    print(credential);
    _setAuth(credential);
    _redirect(credential);
  }
}
