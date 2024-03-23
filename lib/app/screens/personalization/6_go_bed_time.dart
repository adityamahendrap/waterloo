import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/7_activity_level.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class GoToBedPersonalization extends StatelessWidget {
  final personalizationC = Get.find<PersonalizationController>();
  final List<int> hours = List<int>.generate(24, (index) => index);
  final List<int> minutes = List<int>.generate(60, (index) => index);

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ListWheelInputStripe(),
                        ListWheelInput(
                          items: hours,
                          selectedItem: personalizationC.go_bed_time_hour,
                          onSelectedItemChanged: (index) {
                            personalizationC.setGoBedTimeHour(hours[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ListWheelInputStripe(),
                        ListWheelInput(
                          items: minutes,
                          selectedItem: personalizationC.go_bed_time_minute,
                          onSelectedItemChanged: (index) {
                            personalizationC.setGoBedTimeMinute(minutes[index]);
                          },
                        ),
                      ],
                    ),
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
