import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import '../widgets/oauth_button.dart';
import '../widgets/full_width_button.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
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
                  ),
                  SizedBox(height: 15),
                  OauthButton(
                    iconPath: "assets/facebook_icon.png",
                    text: "Continue with Facebook",
                  ),
                  SizedBox(height: 50),
                  FullWidthButton(
                    type: FullWidthButtonType.primary,
                    text: "Sign Up",
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      )
                    },
                  ),
                  SizedBox(height: 15),
                  FullWidthButton(
                    type: FullWidthButtonType.secondary,
                    text: "Sign In",
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignIn(),
                        ),
                      )
                    },
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => {},
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () => {},
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
      ),
    );
  }
}
