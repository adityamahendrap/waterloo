import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/daily_goal.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class WeatherPersonalization extends StatelessWidget {
  WeatherPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();
  final List<Map<String, dynamic>> activityLevels = [
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/2698/2698194.png",
      "primaryText": Weather.HOT,
    },
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/2698/2698213.png",
      "primaryText": Weather.TEMPERATE,
    },
    {
      "iconPath": "https://cdn-icons-png.flaticon.com/128/2273/2273965.png",
      "primaryText": Weather.COLD,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 8),
      body: Stack(
        children: [
          Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(children: [
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
                            selectedItem: personalizationC.weather,
                            onPressed: () {
                              personalizationC.setWeather(item['primaryText']);
                            },
                          ),
                          SizedBox(height: 20)
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 100),
                ]),
              ),
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Finish",
            onPressed: () {
              if (personalizationC.weather.value == "") {
                Get.snackbar(
                  "Message",
                  "Please select your climate / weather condition.",
                );
                return;
              }

              double result = personalizationC.calculateWaterIntake();
              personalizationC.setDailyGoal(result);
              Get.offAll(() => DailyGoal());
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
  final RxString selectedItem;
  final void Function() onPressed;

  const ChoiceButton(
      {Key? key,
      required this.iconPath,
      required this.primaryText,
      required this.selectedItem,
      required this.onPressed})
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
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
            width: this.selectedItem.value == this.primaryText ? 2 : 0.5,
            color: this.selectedItem.value == this.primaryText
                ? Colors.blue
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
