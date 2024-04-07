import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/forgot_password/update_forgotten_password.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:timer_count_down/timer_count_down.dart';

class EnterForgotPasswordCode extends StatefulWidget {
  EnterForgotPasswordCode({Key? key}) : super(key: key);

  @override
  State<EnterForgotPasswordCode> createState() => _EnterForgotPasswordCodeState();
}

class _EnterForgotPasswordCodeState extends State<EnterForgotPasswordCode> {
  final authC = Get.find<AuthController>();
  bool _isResendCodeButtonActive = false;

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
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitle(title: "Enter OTP Code 🔐"),
                SizedBox(height: 10),
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
                  cursorColor: Colors.blue,
                  autoFocus: true,
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  onSubmit: (String verificationCode) {
                    clog.debug('verificationCode: $verificationCode');
                    clog.debug('email: ${Get.arguments['email']}');
                    authC.verifyOTPCode(
                        Get.arguments['email'], verificationCode);
                  },
                ),
                SizedBox(height: 25),
                _isResendCodeButtonActive
                    ? _resendButton()
                    : _countdownResend(),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center _resendButton() {
    return Center(
      child: TextButton(
        child: Text(
          "Resend Code",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        onPressed: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          await authC.resendOTPCode(Get.arguments['email']);
          setState(() {
            _isResendCodeButtonActive = false;
          });
        },
      ),
    );
  }

  Row _countdownResend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("You can resent the code in "),
        Countdown(
          seconds: 60,
          build: (BuildContext context, double time) => Text(
            time.toInt().toString(),
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          onFinished: () {
            setState(() {
              _isResendCodeButtonActive = true;
            });
          },
        ),
        Text(" seconds")
      ],
    );
  }
}
