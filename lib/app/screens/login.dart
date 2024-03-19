import 'package:flutter/material.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GetStarted()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextTitle(title: "Join Waterloo Today!✨"),
            SizedBox(height: 10),
            Text(
                "Create an account to track your water intake, set reminders, and unlock achievements"),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
                Text("I agree to Waterloo "),
                Text(
                  "Terms & Conditions.",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text("Already have an account? "),
                Text(
                  "Sign In",
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("or")],
            ),
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
            SizedBox(height: 15),
            FullWidthButton(
              type: FullWidthButtonType.primary,
              text: "Sign Up",
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
