import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import '../widgets/oauth_button.dart';
import '../widgets/full_width_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GetStarted extends StatelessWidget {
  GetStarted({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage("assets/logo_blue.png")),
                  SizedBox(height: 50),
                  TextTitle(title: "Let's Get Started"),
                  SizedBox(height: 10),
                  Text("Let's dive into your account"),
                  SizedBox(height: 50),
                  OauthButton(
                      iconPath: "assets/google_icon.png",
                      text: "Continue with Google",
                      onPressed: () => authC.google()),
                  SizedBox(height: 15),
                  OauthButton(
                      iconPath: "assets/facebook_icon.png",
                      text: "Continue with Facebook",
                      onPressed: () => authC.facebook()),
                  SizedBox(height: 15),
                  OauthButton(
                      iconPath: "assets/github_icon.png",
                      text: "Continue with GitHub",
                      onPressed: () => authC.github(context)),
                  SizedBox(height: 50),
                  FullWidthButton(
                      type: FullWidthButtonType.primary,
                      text: "Sign Up",
                      onPressed: () => Get.to(() => SignUp())),
                  SizedBox(height: 15),
                  FullWidthButton(
                      type: FullWidthButtonType.secondary,
                      text: "Sign In",
                      onPressed: () => Get.to(() => SignIn())),
                  SizedBox(height: 50),
                ],
              ),
              Positioned(child: _termsAndPolicy(), bottom: 20)
            ],
          ),
        ),
      ),
    );
  }

  Row _termsAndPolicy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(EdgeInsets.all(5)),
          ),
          child: Text("Privacy Policy", style: TextStyle(color: Colors.grey)),
        ),
        SizedBox(width: 20),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(EdgeInsets.all(5)),
          ),
          child: Text("Term of Service", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
