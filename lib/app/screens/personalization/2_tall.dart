import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/3.weight.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';

class TallPersonalization extends StatelessWidget {
  TallPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<int> numbers = List<int>.generate(100, (index) => index + 150);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 2),
      body: Stack(
        children: [
          // Obx(() => Text("talls: ${personalizationC.tall}")),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              children: [
                Center(child: TextTitle(title: "How tall are you?")),
                SizedBox(height: 10),
                Text(
                  "Your height is another key factor in customizing your hidration plan. Choose your height measurement.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: Image.asset("assets/height.png"),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ListWheelInputStripe(),
                        Container(
                          margin: EdgeInsets.only(left: 120, top: 12),
                          child: Text(
                            "cm",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: ListWheelInput(
                            items: numbers,
                            onSelectedItemChanged: (index) {
                              personalizationC.setTall(numbers[index]);
                            },
                            selectedItem: personalizationC.tall,
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
                () => WeightPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}
