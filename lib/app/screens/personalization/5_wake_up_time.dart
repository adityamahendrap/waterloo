import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/2_tall.dart';
import 'package:waterloo/app/screens/personalization/6_go_bed_time.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class WakeUpPersonalization extends StatefulWidget {
  const WakeUpPersonalization({Key? key}) : super(key: key);

  @override
  State<WakeUpPersonalization> createState() => WakeUpPersonalizationState();
}

class WakeUpPersonalizationState extends State<WakeUpPersonalization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 5),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: [
              Center(
                child: TextTitle(
                  title: "What time do you actually wake up?",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your wake up time help us tailor your hydration schedule. Pick your waking hour.",
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
                    child: Text("cm", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Continue",
            onPressed: () {
              Get.to(
                GoToBedPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
