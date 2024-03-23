import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/3.weight.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class TallPersonalization extends StatefulWidget {
  const TallPersonalization({Key? key}) : super(key: key);

  @override
  State<TallPersonalization> createState() => _TallPersonalizationState();
}

class _TallPersonalizationState extends State<TallPersonalization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 2),
      body: Stack(
        children: [
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
                          child: Text("cm", style: TextStyle(fontSize: 20)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: ListWheelInput(),
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
                WeightPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListWheelInputStripe extends StatelessWidget {
  const ListWheelInputStripe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 30,
      height: 75,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class ListWheelInput extends StatelessWidget {
  const ListWheelInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListWheelScrollView(
        itemExtent: 70,
        perspective: 0.004,
        diameterRatio: 2,
        physics: FixedExtentScrollPhysics(),
        children: List.generate(
          100,
          (index) {
            return Center(
              child: Text(
                "${index + 100}",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
