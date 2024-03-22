import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:waterloo/app/screens/forgot_password/enter_otp_code.dart';
import 'package:waterloo/app/screens/personalization/daily_goal.dart';
import 'package:waterloo/app/screens/sign_up.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/horizontal_divider.dart';
import 'package:waterloo/app/widgets/oauth_button.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class WeatherPersonalization extends StatefulWidget {
  const WeatherPersonalization({Key? key}) : super(key: key);

  @override
  State<WeatherPersonalization> createState() => WeatherPersonalizationState();
}

class WeatherPersonalizationState extends State<WeatherPersonalization> {
  List<Map<String, dynamic>> activityLevels = [
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Hot",
      "isSelected": false
    },
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Temperate",
      "isSelected": true
    },
    {
      "iconPath": "assets/google_icon.png",
      "primaryText": "Cold",
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
              percent: 8 / 8,
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
                  "8 / 8",
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
                    title: "What's the climate / weather like in your area?",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "External factor like weather can influence your hydration needs. Let's us know the current climate in your area.",
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
              text: "Finish",
              onPressed: () {
                Get.offAll(DailyGoal());
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
  final bool isSelected;

  const ChoiceButton({
    Key? key,
    required this.iconPath,
    required this.primaryText,
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
