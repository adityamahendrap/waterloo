import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
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
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    clog.info('google credential: ${credential}');

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithGitHub(BuildContext context) async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: "97082719470317a25684",
      clientSecret: "83e9938608ddf74f678aecb210d95e4d61fb38a2",
      redirectUrl: 'https://waterloo-5ec9e.firebaseapp.com/__/auth/handler',
    );

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);
    clog.info('github credential: ${githubAuthCredential}');

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    clog.info('facebook credential: ${facebookAuthCredential}');

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
