import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AppBarPersonalization extends StatelessWidget
    implements PreferredSizeWidget {
  final int step;

  const AppBarPersonalization({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: this.step != 1
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            )
          : SizedBox(width: 10),
      title: new LinearPercentIndicator(
        lineHeight: 10,
        percent: this.step / 8,
        progressColor: Colors.blue,
        barRadius: Radius.circular(100),
        backgroundColor: Colors.grey[300],
      ),
      actions: [
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              "$step / 8",
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
