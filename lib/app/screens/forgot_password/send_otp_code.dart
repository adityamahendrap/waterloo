import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SendOtpCode extends StatelessWidget {
  SendOtpCode({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TextTitle(title: "Forgot Your Password? 🔑"),
              SizedBox(height: 10),
              Text(
                  "No worries! Enter your registered email below to reset your password."),
              SizedBox(height: 25),
              Text(
                "Your Registered Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
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
              SizedBox(height: 100),
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Send OTP Code",
            onPressed: () {
              authC.sendOTPCode(emailController.text);
            },
          ),
        ],
      ),
    );
  }
}
