import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/controllers/personalization_controller.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/widgets/full_width_button_bottom_bar.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class DailyGoal extends StatelessWidget {
  DailyGoal({super.key});

  final personalizationController = Get.find<PersonalizationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: TextTitle(
                  title: "Your daily goal is",
                ),
              ),
              SizedBox(height: 50),
              Image.asset("assets/water_result.png"),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      personalizationController.dailyGoal.value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      " mL",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () {},
                icon: SizedBox(
                  height: 24,
                  child: Icon(Icons.adjust_outlined),
                ),
                label: Text(
                  "Adjust",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 50),
                  shape: StadiumBorder(),
                ),
              )
            ],
          ),
          FullWidthButtonBottomBar(
            context: context,
            text: "Let's Hydrate",
            onPressed: () {
              Get.offAll(Home());
            },
          )
        ],
      ),
    );
  }
}
