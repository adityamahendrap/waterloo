import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/4_age.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';

class WeightPersonalization extends StatelessWidget {
  WeightPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<int> numbers = List<int>.generate(150, (index) => index + 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 3),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              children: [
                Center(child: TextTitle(title: "How much do you weight?")),
                SizedBox(height: 10),
                Text(
                  "Your weight play a crucial role in determining your hydration needs. Select your weight below.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: Image.asset("assets/weight.png"),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ListWheelInputStripe(),
                        Container(
                          margin: EdgeInsets.only(left: 120, top: 12),
                          child: Text(
                            "kg",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: ListWheelInput(
                            items: numbers,
                            onSelectedItemChanged: (index) {
                              personalizationC.weight.value = numbers[index];
                            },
                            selectedItem: personalizationC.weight,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Continue",
            onPressed: () {
              Get.to(
                () => AgePersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
