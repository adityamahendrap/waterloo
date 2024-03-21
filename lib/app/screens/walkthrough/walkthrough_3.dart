import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';

class Walkthrough3 extends StatelessWidget {
  const Walkthrough3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Achieve Your Hydration Goals With Waterloo Now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Level up your hydration with Waterloo's achievements. Use all features, and make hydration a lifelong habit.",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            bottomBar(context),
          ],
        ),
      ),
    );
  }

  Positioned bottomBar(BuildContext context) {
    return Positioned(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            new DotsIndicator(
              dotsCount: 3,
              position: 2,
              decorator: DotsDecorator(
                color: Color(0xffEEEEEE),
                spacing: EdgeInsets.all(4),
                size: const Size.square(9.0),
                activeSize: const Size(30.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FullWidthButton(
                type: FullWidthButtonType.primary,
                text: "Let's Get Started",
                onPressed: () {
                  Get.offAll(GetStarted());
                },
              ),
            ),
          ],
        ),
      ),
      bottom: 0,
    );
  }
}
