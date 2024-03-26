import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/oauth_controller.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import '../widgets/oauth_button.dart';
import '../widgets/full_width_button.dart';

class GetStarted extends StatelessWidget {
  GetStarted({Key? key}) : super(key: key);

  final oauthC = OAuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
        children: [
          Center(
            child: Column(
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
                  onPressed: () async {
                    oauthC.google();
                  },
                ),
                SizedBox(height: 15),
                OauthButton(
                  iconPath: "assets/facebook_icon.png",
                  text: "Continue with Facebook",
                  onPressed: () async {
                    oauthC.facebook();
                  },
                ),
                SizedBox(height: 15),
                OauthButton(
                  iconPath: "assets/github_icon.png",
                  text: "Continue with GitHub",
                  onPressed: () async {
                    oauthC.github(context);
                  },
                ),
                SizedBox(height: 50),
                FullWidthButton(
                  type: FullWidthButtonType.primary,
                  text: "Sign Up",
                  onPressed: () {
                    Get.to(() => SignUp());
                  },
                ),
                SizedBox(height: 15),
                FullWidthButton(
                  type: FullWidthButtonType.secondary,
                  text: "Sign In",
                  onPressed: () {
                    Get.to(() => SignIn());
                  },
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Term of Service",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
