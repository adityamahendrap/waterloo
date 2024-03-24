import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/5_wake_up_time.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';

class AgePersonalization extends StatelessWidget {
  AgePersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<int> numbers = List<int>.generate(80, (index) => index + 6);

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
                      ListWheelInput(
                        items: numbers,
                        selectedItem: personalizationC.age,
                        onSelectedItemChanged: (index) {
                          personalizationC.setAge(numbers[index]);
                        },
                      ),
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
                () => WakeUpPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
