import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/4_age.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class WeightPersonalization extends StatefulWidget {
  const WeightPersonalization({Key? key}) : super(key: key);

  @override
  State<WeightPersonalization> createState() => _WeightPersonalizationState();
}

class _WeightPersonalizationState extends State<WeightPersonalization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 3),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: [
              Center(child: TextTitle(title: "How much do you weight?")),
              SizedBox(height: 10),
              Text(
                "Your weight play a crucial role in determining your hydration needs. Select your weight below.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: Image.asset("assets/weight.png"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: null,
                  )
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
                AgePersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
