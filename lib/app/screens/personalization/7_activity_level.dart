import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/8_weather.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class ActicityLabelPersonalization extends StatefulWidget {
  const ActicityLabelPersonalization({Key? key}) : super(key: key);

  @override
  State<ActicityLabelPersonalization> createState() =>
      ActicityLabelPersonalizationState();
}

class ActicityLabelPersonalizationState
    extends State<ActicityLabelPersonalization> {
  List<Map<String, dynamic>> activityLevels = [
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Sedentary",
      "secondaryText":
          "Limited physical activity, mostly sitting or laying down.",
      "isSelected": false
    },
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Light Activity",
      "secondaryText":
          "Some movement throughout the day, such as ligh walking or occasional standing.",
      "isSelected": true
    },
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Moderate Activity",
      "secondaryText":
          "Regural excercise or physical activity, such as jogging or cycling.",
      "isSelected": false
    },
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Very Active",
      "secondaryText":
          "Intense pyshical activity or training, such as heavy lifting or high-intensity training.",
      "isSelected": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: Expanded(
            child: new LinearPercentIndicator(
              lineHeight: 10,
              percent: 7 / 8,
              progressColor: Colors.blue,
              barRadius: Radius.circular(100),
              backgroundColor: Colors.grey[300],
            ),
          ),
          actions: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  "7 / 8",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 20),
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              children: [
                Center(
                  child: TextTitle(
                    title: "What's your activity level?",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Understanding your activity is vital for crafting a personalized hydration plan. Pick the option that best describes your typical activity level.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Column(
                  children: activityLevels.map((item) {
                    return Column(
                      children: [
                        ChoiceButton(
                          iconPath: item['iconPath'],
                          primaryText: item['primaryText'],
                          secondaryText: item['secondaryText'],
                          isSelected: item['isSelected'],
                        ),
                        SizedBox(height: 20)
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 100),
              ],
            ),
            FullWidthButtonBottomBar(
              context: context,
              text: "Continue",
              onPressed: () {
                Get.to(WeatherPersonalization());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String iconPath;
  final String primaryText;
  final String secondaryText;
  final bool isSelected;

  const ChoiceButton({
    Key? key,
    required this.iconPath,
    required this.primaryText,
    required this.secondaryText,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: SizedBox(
        height: 24,
        child: Image.asset(this.iconPath),
      ),
      label: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.primaryText,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    this.secondaryText,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(
          width: this.isSelected ? 2 : 0.5,
          color: this.isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
