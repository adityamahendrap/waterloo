import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/reset_password_success.png"),
                    SizedBox(height: 30),
                    TextTitle(title: "You're All Set!"),
                    SizedBox(height: 15),
                    Text("Your password successfully updated")
                  ],
                ),
              ),
            ),
            FullWidthButtonBottomBar(
              context: context,
              text: "Go To Homepage",
              onPressed: () {
                Get.offAll(GetStarted());
              },
            ),
          ],
        ),
      ),
    );
  }
}
