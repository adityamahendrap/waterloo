import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/7_activity_level.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class GoToBedPersonalization extends StatefulWidget {
  const GoToBedPersonalization({Key? key}) : super(key: key);

  @override
  State<GoToBedPersonalization> createState() => GoToBedPersonalizationState();
}

class GoToBedPersonalizationState extends State<GoToBedPersonalization> {
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
          title: Expanded(
            child: new LinearPercentIndicator(
              lineHeight: 10,
              percent: 6 / 8,
              progressColor: Colors.blue,
              barRadius: Radius.circular(100),
              backgroundColor: Colors.grey[300],
            ),
          ),
          actions: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  "6 / 8",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 20),
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                Center(
                  child: TextTitle(
                    title: "What time do you actually go bed?",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your bed time influence your hydration pattern. Choose your typical bedtime.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Row(
                  children: [],
                ),
                SizedBox(height: 100),
              ],
            ),
            FullWidthButtonBottomBar(
              context: context,
              text: "Continue",
              onPressed: () {
                Get.to(ActicityLabelPersonalization());
              },
            ),
          ],
        ),
      ),
    );
  }
}
