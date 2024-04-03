import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waterloo/app/utils/helpless.dart';

class AuthService {
  static Future<Map<String, dynamic>> checkOrCreateUser(
      UserCredential credential) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    clog.debug('checkOrCreateUser');
    DocumentSnapshot<Object?> userSnapshot =
        await users.doc(credential.user!.uid).get();

    if (!userSnapshot.exists) {
      await users
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

      userSnapshot = await users.doc(credential.user!.uid).get();
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
}
