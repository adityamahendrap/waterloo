import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/personalization/2_tall.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class GenderPersonalization extends StatelessWidget {
  GenderPersonalization({super.key});

  final personalizationC = Get.find<PersonalizationController>();

  final genderButtonActiveStyle = {
    "bgColor": Colors.blue,
    "borderColor": Colors.blue,
    "iconColor": Colors.white,
    "textColor": Colors.blue
  };

  final genderButtonInactiveStyle = {
    "bgColor": Colors.white,
    "borderColor": Colors.grey,
    "iconColor": Colors.black,
    "textColor": Colors.black
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarPersonalization(step: 1),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            children: [
              Center(child: TextTitle(title: "What's your gender?")),
              SizedBox(height: 10),
              Text(
                "Waterloo is here to taylor a hidration plan just for you! Let's kick thing off by getting to know you better",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GenderButton(
                      onPressed: () {
                        personalizationC.setGender(Gender.MALE);
                      },
                      icon: Icons.male,
                      text: "Male",
                      style: personalizationC.gender == Gender.MALE
                          ? genderButtonActiveStyle
                          : genderButtonInactiveStyle,
                    ),
                    GenderButton(
                      onPressed: () {
                        personalizationC.setGender(Gender.FEMALE);
                      },
                      icon: Icons.female,
                      text: "Female",
                      style: personalizationC.gender == Gender.FEMALE
                          ? genderButtonActiveStyle
                          : genderButtonInactiveStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Align(
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      personalizationC.setGender(Gender.SECRET);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: personalizationC.gender == Gender.SECRET
                          ? genderButtonActiveStyle["bgColor"]
                          : genderButtonInactiveStyle["bgColor"],
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Prefer not to say",
                      style: TextStyle(
                        color: personalizationC.gender == Gender.SECRET
                            ? Colors.white
                            : genderButtonInactiveStyle["textColor"],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Continue",
            onPressed: () {
              Get.to(
                TallPersonalization(),
                transition: Transition.noTransition,
              );
            },
          ),
        ],
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String text;
  final Map style;

  const GenderButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: this.style["borderColor"]),
            shape: BoxShape.circle,
            color: this.style["bgColor"],
          ),
          child: IconButton(
            onPressed: () {
              this.onPressed();
            },
            icon: Icon(this.icon),
            color: this.style["iconColor"],
            iconSize: 70,
          ),
        ),
        SizedBox(height: 20),
        Text(
          this.text,
          style: TextStyle(color: this.style["textColor"], fontSize: 20),
        )
      ],
    );
  }
}
