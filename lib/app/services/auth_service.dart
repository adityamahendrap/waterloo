import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waterloo/app/utils/go_go_exception.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AuthService {
  static Future<Map<String, dynamic>> checkOrCreateUser(
      UserCredential credential) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    clog.debug('checkOrCreateUser');
    DocumentSnapshot<Object?> userSnapshot =
        await usersRef.doc(credential.user!.uid).get();

    if (!userSnapshot.exists) {
      await usersRef
          .doc(credential.user!.uid)
          .set({
            'uid': credential.user?.uid,
            'email': credential.user?.email,
            'name': credential.user?.displayName,
            'photo_url': credential.user?.photoURL,
            'provider': credential.credential?.providerId,
            'personalization': null,
            'daily_goal': null,
            'created_at': FieldValue.serverTimestamp(),
          })
          .then((_) => clog.info("user added"))
          .catchError((error) {
            clog.error("failed to add user: $error");
            throw error;
          });

      userSnapshot = await usersRef.doc(credential.user!.uid).get();
    } else
      clog.info('user exists');

    Map<String, dynamic> user = userSnapshot.data() as Map<String, dynamic>;
    user['created_at'] =
        HelplessUtil.timestampToIso8601String(user['created_at'] as Timestamp);
    clog.info('user data: $user');

    return user;
  }

  static Future<UserCredential> signUpWithEmail(
      String email, String password) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    clog.info('email credential: ${credential}');

    return credential;
  }

  static Future<UserCredential> signInWithEmail(
      String email, String password) async {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    clog.info('email credential: ${credential}');
    return credential;
  }

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    clog.info('google credential: ${credential}');

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: "97082719470317a25684",
      clientSecret: "83e9938608ddf74f678aecb210d95e4d61fb38a2",
      redirectUrl: 'https://waterloo-5ec9e.firebaseapp.com/__/auth/handler',
    );
    final result = await gitHubSignIn.signIn(context);

    final githubAuthCredential = GithubAuthProvider.credential(result.token!);
    clog.info('github credential: ${githubAuthCredential}');

    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    clog.info('facebook credential: ${facebookAuthCredential}');

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<void> forgotPasswordAccountCheck(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userSnapshot = await users.where('email', isEqualTo: email).get();

    if (userSnapshot.docs.isEmpty) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'Account not found');
    }

    final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

    if (userData['provider'] != null) {
      throw FirebaseAuthException(
          code: 'user-exists', message: 'Account exists with other provider');
    }
  }

  static Future<String> generateAndSaveOTPCode(String email) async {
    String otpCode = (Random().nextInt(9000) + 1000).toString();
    DateTime otpCodeExpiry = DateTime.now().add(Duration(minutes: 5));

    // Save OTP code to Firestore
    final forgotPasswordRef =
        FirebaseFirestore.instance.collection('forgot_password');
    await forgotPasswordRef.add({
      'email': email,
      'otp_code': otpCode,
      'otp_code_expiry': otpCodeExpiry,
    });
    clog.info('OTP code generated and saved: $otpCode');

    return otpCode;
  }

  static Future<void> sendOTPCodeWithEmail(
      String emailRecipient, String otpCode) async {
    String username = 'itecece2023dev@gmail.com';
    String password = 'idrelfvkggtuymcp';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Waterloo')
      ..recipients.add(emailRecipient)
      ..subject = 'Waterloo Forgot Password OTP Code'
      ..text = 'Your OTP code is $otpCode. It will expire in 5 minutes.';

    try {
      final sendReport = await send(message, smtpServer);
      clog.info('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      clog.error('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      throw GoGoException('Failed to send OTP code, please try again later');
    }
  }

  static Future<void> deletePreviousOTPCode(String email) async {
    final forgotPasswordRef =
        FirebaseFirestore.instance.collection('forgot_password');
    final snapshot =
        await forgotPasswordRef.where('email', isEqualTo: email).get();

    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) {
        forgotPasswordRef.doc(doc.id).delete();
      });
      clog.info('previous $email OTP code deleted');
    } else {
      clog.info('no previous $email OTP code found');
    }
  }

  static Future<void> verifyOTPCode(String email, String otpCode) async {
    final forgotPasswordRef =
        FirebaseFirestore.instance.collection('forgot_password');
    final snapshot = await forgotPasswordRef
        .where('email', isEqualTo: email)
        .where('otp_code', isEqualTo: otpCode)
        .get();

    if (snapshot.docs.isEmpty) {
      throw GoGoException('Invalid OTP code');
    }

    // check if OTP code is expired (5 minutes)
    final otpCodeData = snapshot.docs.first.data();
    final idOtpCodeExpired =
        (otpCodeData['otp_code_expiry'] as Timestamp).toDate();
    if (DateTime.now().isAfter(idOtpCodeExpired)) {
      throw GoGoException(
          'OTP code has been expired, please request a new one');
    }

    clog.info('OTP code verified');
  }
}
