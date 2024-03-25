import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/sign_up_controller.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final signUpC = Get.put(SignUpController());
  final signUpValidator = SignUpValidator();

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
              TextTitle(title: "Join Waterloo Today!✨"),
              SizedBox(height: 10),
              Text(
                  "Create an account to track your water intake, set reminders, and unlock achievements"),
              SizedBox(height: 25),
              Form(
                key: signUpC.signUpFormKey,
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
                    Obx(
                      () => _passwordInput(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Confirm Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => _confirmPasswordInput(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Obx(
                      () => Checkbox(
                        value: signUpC.isAgree.value,
                        onChanged: (value) => signUpC.isAgree.toggle(),
                        activeColor: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("I agree to Waterloo "),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(
                      "Terms & Conditions.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.off(SignIn());
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
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
          FullWidthButtonBottomBar(
            context: context,
            text: "Sign Up",
            onPressed: () {
              if (!signUpValidator.isValid()) {
                AppSnackBar.error("Failed", "Please fill the form correctly");
                return;
              } else if (!signUpC.isAgree.value) {
                AppSnackBar.error("Failed", "Please agree to the terms");
                return;
              }
              signUpC.firebaseEmailSignUp();
            },
          ),
        ],
      ),
    );
  }

  TextFormField _confirmPasswordInput() {
    return TextFormField(
      controller: signUpC.confirmPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => signUpValidator.email(value),
      textAlignVertical: TextAlignVertical.center,
      obscureText: signUpC.isConfirmPasswordHidden.value,
      cursorErrorColor: Colors.blue,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.black,
        ),
        hintText: "Confirm Password",
        hintStyle: TextStyle(color: Color(0xff9E9E9E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Color.fromARGB(101, 241, 241, 241),
        suffixIcon: IconButton(
          icon: Icon(
            signUpC.isConfirmPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            signUpC.isConfirmPasswordHidden.toggle();
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

  TextFormField _passwordInput() {
    return TextFormField(
      controller: signUpC.passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => signUpValidator.password(value),
      textAlignVertical: TextAlignVertical.center,
      obscureText: signUpC.isPasswordHidden.value,
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
            signUpC.isPasswordHidden.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            signUpC.isPasswordHidden.toggle();
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
      controller: signUpC.emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => signUpValidator.confirmPassword(value),
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
