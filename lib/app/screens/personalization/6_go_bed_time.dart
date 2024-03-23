import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/7_activity_level.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 6),
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
              Get.to(
                ActicityLabelPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
