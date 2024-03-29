import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:color_log/color_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/controllers/nav_controller.dart';
import 'package:waterloo/app/controllers/water_controller.dart';
import 'package:waterloo/app/widgets/main_appbarr.dart';
import 'package:water_bottle/water_bottle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final waterC = Get.put(WaterController());
  final navC = Get.put(NavController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    waterC.setDailyGoal();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      waterC.sphereBottleRef.currentState?.waterLevel = waterC.waterLevel.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(
        title: "Home",
        backgroundColor: Color(0xffF5F5F5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _WaterCounter(),
              SizedBox(height: 20),
              _TodayHistory(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  Widget _BottomNavBar() {
    return Obx(() => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navC.selectedIndex.value,
          selectedItemColor: Colors.blue,
          onTap: (index) => navC.selectedIndex.value = index,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              activeIcon: Icon(Icons.home_filled),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: 'History',
              activeIcon: Icon(Icons.history),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report_outlined),
              label: 'Report',
              activeIcon: Icon(Icons.report),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: 'Achievements',
              activeIcon: Icon(Icons.emoji_events),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
              activeIcon: Icon(Icons.account_circle),
            ),
          ],
        ));
  }

  Container _TodayHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    elevation: 0,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.white,
                  ),
                  label: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: Icon(Icons.arrow_back, color: Colors.blue),
                ),
              )
            ],
          ),
          Divider(),
          // Column(
          //   children: [
          // SizedBox(height: 10),
          //     Image.asset("assets/logo_blue.png"),
          //     SizedBox(height: 20),
          //     Text("You have no history on water intake today."),
          //     SizedBox(height: 10),
          //   ],
          // ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 8),
                leading: Image.asset(
                  "assets/glass-of-water.png",
                  width: 32,
                  height: 32,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Water",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "15.00 PM",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Text(
                          "200mL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.more_vert),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Divider(),
            ],
          ),
        ],
      ),
    );
  }

  Container _WaterCounter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 25),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2,
                ),
                child: AspectRatio(
                  aspectRatio: 0.99,
                  child: SizedBox(
                    width: 100,
                    child: SphericalBottle(
                      key: waterC.sphereBottleRef,
                      waterColor: Colors.blue,
                      bottleColor: Colors.blue,
                      capColor: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => AnimatedDigitWidget(
                value: waterC.currentWater.value.toInt(),
                textStyle: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                duration: Duration(milliseconds: 500),
              ),
            ),
            Text("/${waterC.dailyGoal.value.toInt()}mL",
                style: TextStyle(fontSize: 17)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => waterC.drinkWater(200),
                  child: Text(
                    "Drink (200mL)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF369FFF),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                SizedBox(width: 20),
                Stack(
                  children: [
                    IconButton.outlined(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: EdgeInsets.all(12),
                      ),
                      icon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/glass-of-water.png"),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: Container(
                        width: 24,
                        height: 24,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Image.asset(
                          "assets/switch_arrow.png",
                          opacity: AlwaysStoppedAnimation(0.5),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
