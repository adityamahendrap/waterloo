import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/8_weather.dart';
import 'package:waterloo/app/utils/AppSnackBar.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class ActicityLabelPersonalization extends StatelessWidget {
  ActicityLabelPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<Map<String, dynamic>> activityLevels = [
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/9896/9896605.png",
      "primaryText": "Sedentary",
      "level": ActivityLevel.SEDENTARY,
      "secondaryText":
          "Limited physical activity, mostly sitting or laying down.",
    },
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/5147/5147215.png",
      "primaryText": "Light Activity",
      "level": ActivityLevel.LIGHTLY_ACTIVE,
      "secondaryText":
          "Some movement throughout the day, such as ligh walking or occasional standing.",
    },
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/384/384276.png",
      "primaryText": "Moderate Activity",
      "level": ActivityLevel.MODERATELY_ACTIVE,
      "secondaryText":
          "Regural excercise or physical activity, such as jogging or cycling.",
    },
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/2112/2112333.png",
      "primaryText": "Very Active",
      "level": ActivityLevel.VERY_ACTIVE,
      "secondaryText":
          "Intense pyshical activity or training, such as heavy lifting or high-intensity training.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 7),
      body: Stack(
        children: [
          ListView(padding: EdgeInsets.fromLTRB(20, 30, 20, 20), children: [
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
                      level: item['level'],
                      selectedLevel: personalizationC.activityLevel,
                      onPressed: () {
                        personalizationC.activityLevel.value = item["level"];
                      },
                    ),
                    SizedBox(height: 20)
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 100),
          ]),
          FullWidthButtonBottomBar(
            context: context,
            text: "Continue",
            onPressed: () {
              if (personalizationC.activityLevel.value == 0) {
                AppSnackBar.error("Failed", "Please select an activity level");
                return;
              }
              Get.to(
                () => WeatherPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String iconPath;
  final String primaryText;
  final String secondaryText;
  final void Function() onPressed;
  final RxInt selectedLevel;
  final int level;

  const ChoiceButton(
      {Key? key,
      required this.iconPath,
      required this.primaryText,
      required this.secondaryText,
      required this.onPressed,
      required this.selectedLevel,
      required this.level})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OutlinedButton.icon(
        onPressed: () {
          this.onPressed();
        },
        icon: SizedBox(
          height: 40,
          width: 40,
          child: Image.network(this.iconPath),
        ),
        label: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
            width: this.level == this.selectedLevel.value ? 2 : 0.5,
            color: this.level == this.selectedLevel.value
                ? Colors.blue
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
