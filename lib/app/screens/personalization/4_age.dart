import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/2_tall.dart';
import 'package:waterloo/app/screens/personalization/5_wake_up_time.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class AgePersonalization extends StatefulWidget {
  const AgePersonalization({Key? key}) : super(key: key);

  @override
  State<AgePersonalization> createState() => _AgePersonalizationState();
}

class _AgePersonalizationState extends State<AgePersonalization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 4),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                children: [
                  Center(child: TextTitle(title: "What's your age?")),
                  SizedBox(height: 10),
                  Text(
                    "Age also have impacts to your body's hydration needs. Scroll and select your age from the action below.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ListWheelInput(),
                      ListWheelInputStripe(),
                      Container(
                        margin: EdgeInsets.only(left: 120, top: 12),
                        child: Text("yrs", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Continue",
            onPressed: () {
              Get.to(
                WakeUpPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
