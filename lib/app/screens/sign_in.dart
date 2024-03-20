import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/utils/navigator_util.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GetStarted(),
                ),
              )
            },
          ),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                TextTitle(title: "Welcome Back 👋"),
                SizedBox(height: 10),
                Text(
                    "Sign in to your account to continue your journey towards a healthier you."),
                SizedBox(height: 25),
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xff9E9E9E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(101, 241, 241, 241),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color(0xff9E9E9E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(101, 241, 241, 241),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () => {},
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: true,
                            onChanged: (value) => {},
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () => {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Doesn't have an account? "),
                    TextButton(
                      onPressed: () => {
                        NavigatorUtil.push(context, const SignUp(), true),
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                HorizontalDivider(text: "or"),
                SizedBox(height: 25),
                OauthButton(
                  iconPath: "assets/google_icon.png",
                  text: "Continue with Google",
                ),
                SizedBox(height: 15),
                OauthButton(
                  iconPath: "assets/facebook_icon.png",
                  text: "Continue with Facebook",
                ),
                SizedBox(height: 100),
              ],
            ),
            bottomBar(context),
          ],
        ),
      ),
    );
  }

  Positioned bottomBar(BuildContext context) {
    return Positioned(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FullWidthButton(
                type: FullWidthButtonType.primary,
                text: "Sign In",
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
      bottom: 0,
    );
  }
}
