import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/screens/walkthrough/introduction.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Get.offAll(Introduction());
    });

    return Scaffold(
      backgroundColor: Color(0xff369FFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/logo_white.png"),
            SizedBox(height: 20),
            Text(
              "Waterloo",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
