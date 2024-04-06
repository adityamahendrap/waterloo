import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/controllers/sign_in_controller.dart';
import 'package:waterloo/app/screens/forgot_password/send_otp_code.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/utils/app_snack_bar.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final signInC = Get.put(SignInController());
  final signInValidator = SignInValidator();

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
              TextTitle(title: "Welcome Back 👋"),
              SizedBox(height: 10),
              Text(
                  "Sign in to your account to continue your journey towards a healthier you."),
              SizedBox(height: 25),
              Form(
                key: signInC.signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _emailInput(),
                    SizedBox(height: 20),
                    Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Obx(() => _passwordInput()),
                  ],
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
                        child: Obx(
                          () => Checkbox(
                            value: signInC.isRememberMe.value,
                            onChanged: (value) => signInC.isRememberMe.toggle(),
                            activeColor: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SendOtpCode());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Doesn't have an account? "),
                  TextButton(
                    onPressed: () {
                      Get.off(() => SignUp());
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              HorizontalDivider(text: "or"),
              SizedBox(height: 25),
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
              SizedBox(height: 100),
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Sign In",
            onPressed: () {
              signInC.signIn(signInValidator);
            },
          ),
        ],
      ),
    );
  }

  TextFormField _passwordInput() {
    return TextFormField(
      controller: signInC.passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => signInValidator.password(value),
      textAlignVertical: TextAlignVertical.center,
      obscureText: signInC.isPasswordHidden.value,
      cursorColor: Colors.blue,
      cursorErrorColor: Colors.blue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
            signInC.isPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            signInC.isPasswordHidden.toggle();
          },
        ),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }

  TextFormField _emailInput() {
    return TextFormField(
      controller: signInC.emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => signInValidator.email(value),
      textAlignVertical: TextAlignVertical.center,
      obscureText: false,
      cursorColor: Colors.blue,
      cursorErrorColor: Colors.blue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}
