import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/widgets/main_appbarr.dart';
import 'package:water_bottle/water_bottle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  var waterLevel = 0.1;
  Timer? timer;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementWaterLevel(double target) {
    const duration = const Duration(milliseconds: 100);
    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        if (waterLevel >= 1.0) {
          timer?.cancel();
        } else if (waterLevel >= target) {
          timer?.cancel();
        } else {
          waterLevel += 0.01;
          sphereBottleRef.currentState?.waterLevel = waterLevel;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      sphereBottleRef.currentState?.waterLevel = waterLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
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
                // Slider(
                //   value: waterLevel,
                //   max: 1.0,
                //   min: 0.0,
                //   onChanged: (value) {
                //     setState(() {
                //       waterLevel = value;
                //       sphereBottleRef.currentState?.waterLevel = waterLevel;
                //     });
                //   },
                // ),
                _WaterCounter(),
                SizedBox(height: 20),
                _TodayHistory(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _BottomNavBar(),
      ),
    );
  }

  BottomNavigationBar _BottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Achievements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Account',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
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
        padding: const EdgeInsets.all(25),
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
                      key: sphereBottleRef,
                      waterColor: Colors.blue,
                      bottleColor: Colors.blue,
                      capColor: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "0",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            Text("/2500mL", style: TextStyle(fontSize: 17)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    double target = waterLevel + (200 / 2500);
                    _incrementWaterLevel(target);
                  },
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
