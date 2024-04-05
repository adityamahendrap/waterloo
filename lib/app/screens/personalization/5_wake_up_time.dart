import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/6_go_bed_time.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';

class WakeUpPersonalization extends StatelessWidget {
  WakeUpPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<int> hours = List<int>.generate(24, (index) => index);
  final List<int> minutes = List<int>.generate(60, (index) => index);

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
                          selectedItem: personalizationC.wakeUpTimeHour,
                          onSelectedItemChanged: (index) {
                            personalizationC.wakeUpTimeHour.value =
                                hours[index];
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
                          selectedItem: personalizationC.wakeUpTimeMinute,
                          onSelectedItemChanged: (index) {
                            personalizationC.wakeUpTimeMinute.value =
                                minutes[index];
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
                () => GoToBedPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
