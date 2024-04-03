import 'dart:developer';

import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:waterloo/app/controllers/auth_controller.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';

// !! https://firebase.flutter.dev/docs/auth/social
class OAuthController extends AuthController {
  GetStorage box = GetStorage();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _handleErr(dynamic e) {
    AppSnackBar.error("Failed",
        e is FirebaseAuthException ? e.message! : "Unknown error occurred");
  }

  void google() async {
    try {
      final UserCredential credential = await AuthService.signInWithGoogle();
      final user = await checkOrCreateUser(credential);
      cacheUser(user);
      redirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }

  void facebook() async {
    try {
      final UserCredential credential = await AuthService.signInWithFacebook();
      final user = await checkOrCreateUser(credential);
      cacheUser(user);
      redirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }

  void github(BuildContext context) async {
    try {
      final UserCredential credential =
          await AuthService.signInWithGitHub(context);
      final user = await checkOrCreateUser(credential);
      cacheUser(user);
      redirect(user);
    } catch (e) {
      _handleErr(e);
    }
  }
}
