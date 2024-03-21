import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/walkthrough/walkthrough_2.dart';

class Walkthrough1 extends StatelessWidget {
  const Walkthrough1({Key? key}) : super(key: key);

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
                    "Waterloo - Your Ultimate Hidration Companion",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Stay healthy & conquer your hidration goals! Track your water intake, set reminders, and unlock achievements for a healthier you.",
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
              position: 0,
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
              thickness: 0.3,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.off(GetStarted());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF369FFF),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: Color(0xFFEFF7FF),
                          elevation: 0,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(Walkthrough2());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Continue",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: 0,
    );
  }
}
