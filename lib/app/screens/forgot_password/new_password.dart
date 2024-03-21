import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/forgot_password/success.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key}) : super(key: key);

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
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                TextTitle(title: "Secure your account 🔒"),
                SizedBox(height: 10),
                Text(
                    "Choose a new password for your Waterloo account. Make sure it's strong and memorable."),
                SizedBox(height: 25),
                Text(
                  "New Password",
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
                    hintText: 'New Password',
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
                      onPressed: () {},
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Confirm New Password",
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
                    hintText: "Confirm New Password",
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
                      onPressed: () {},
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
            FullWidthButtonBottomBar(
              context: context,
              text: "Save New Password",
              onPressed: () {
                Get.offAll(Success());
              },
            ),
          ],
        ),
      ),
    );
  }
}
