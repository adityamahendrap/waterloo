import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/forgot_password/new_password.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class EnterOtpCode extends StatelessWidget {
  const EnterOtpCode({Key? key}) : super(key: key);

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
                TextTitle(title: "Enter OTP Code 🔐"),
                SizedBox(height: 10),
                Text(
                    "We've sent an OTP code to your email. Please check your inbox and enter the code below."),
                SizedBox(height: 25),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.key_outlined,
                      color: Colors.black,
                    ),
                    hintText: 'Code',
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
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You can reset the code in "),
                    Text(
                      "56",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(" seconds")
                  ],
                ),
                Center(
                  child: TextButton(
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 100)
              ],
            ),
            FullWidthButtonBottomBar(
              context: context,
              text: "Submit",
              onPressed: () {
                Get.off(NewPassword());
              },
            ),
          ],
        ),
      ),
    );
  }
}
