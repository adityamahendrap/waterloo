import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/forgot_password/new_password.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class EnterOtpCode extends StatelessWidget {
  const EnterOtpCode({Key? key}) : super(key: key);

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
              TextTitle(title: "Enter OTP Code 🔐"),
              SizedBox(height: 10),
              Text(
                  "We've sent an OTP code to your email. Please check your inbox and enter the code below."),
              Text(
                  "We've sent an OTP code to your email. Please check your inbox and enter the code below."),
              SizedBox(height: 25),
              OtpTextField(
                numberOfFields: 4,
                showFieldAsBox: true,
                onCodeChanged: (String code) {},
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                fieldWidth: MediaQuery.of(context).size.width / 5,
                filled: true,
                fillColor: Color.fromARGB(3, 0, 0, 0),
                borderColor: Colors.white,
                enabledBorderColor: Colors.white,
                focusedBorderColor: Colors.blue,
                autoFocus: true,
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                onSubmit: (String verificationCode) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    },
                  );
                },
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
    );
  }
}
