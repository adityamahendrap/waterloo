import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/screens/personalization/2_tall.dart';
import 'package:waterloo/app/widgets/appbar_personalization.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GenderPersonalization extends StatefulWidget {
  const GenderPersonalization({super.key});

  @override
  State<GenderPersonalization> createState() => _GenderPersonalizationState();
}

class _GenderPersonalizationState extends State<GenderPersonalization> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20 + 1),
                        decoration: BoxDecoration(
                          border: null,
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.male),
                          color: Colors.white,
                          iconSize: 70,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Male",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20 + 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.female),
                          color: Colors.black,
                          iconSize: 70,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Female",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 50),
              Align(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text(
                    "Prefer not to say",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
