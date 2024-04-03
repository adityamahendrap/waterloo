import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:lottie/lottie.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: listPagesViewModel,
        onDone: () {
          Get.find<AuthController>().box.write('isFirstTime', false);
          Get.offAll(() => GetStarted());
        },
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF369FFF),
          ),
        ),
        skipStyle: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Color(0xFFEFF7FF),
          elevation: 0,
        ),
        next: Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        nextStyle: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Color(0xFF369FFF),
          elevation: 0,
        ),
        done: const Text(
          "Start",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        doneStyle: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Color(0xFF369FFF),
          elevation: 0,
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }

  List<PageViewModel> get listPagesViewModel {
    return [
      PageViewModel(
        titleWidget: Text(
          "Waterloo - Your Ultimate Hidration Companion",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        body:
            "Stay healthy & conquer your hidration goals! Track your water intake, set reminders, and unlock achievements for a healthier you.",
        image: Container(
          width: Get.width * 0.6,
          height: Get.width * 0.6,
          child: Center(
            child: Image.asset("assets/intro1.png"),
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          "Track Your Hidration & Visualize Your Progress",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        body:
            "Set reminders to stay consistent, review your daily hidration history and visualize your progress over time.",
        image: Container(
          width: Get.width * 0.6,
          height: Get.width * 0.6,
          child: Center(
            child: Image.asset("assets/intro2.png"),
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Text(
          "Achieve Your Hydration Goals With Waterloo Now",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        body:
            "Level up your hydration with Waterloo's achievements. Use all features, and make hydration a lifelong habit.",
        image: Container(
          width: Get.width * 0.6,
          height: Get.width * 0.6,
          child: Center(
            child: Lottie.asset("assets/lottie/intro3.json"),
          ),
        ),
      ),
    ];
  }
}
