import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/constants/beverage_list.dart';
import 'package:waterloo/app/controllers/nav_controller.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/screens/cup_size/switch_cup_size.dart';
import 'package:waterloo/app/utils/app_snack_bar.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/drink/edit_drink_main.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:waterloo/app/widgets/loading.dart';
import 'package:waterloo/app/widgets/main_appbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:waterloo/app/widgets/wrapper/bottom_sheet_fit_content_wrapper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navC = Get.put(NavController());
  final waterC = Get.put(WaterController());

  @override
  void initState() {
    super.initState();

    waterC.setDailyGoal();
    waterC.fetchTodayDrinkHistory();

    // set water level UI default to 0
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      waterC.sphereBottleRef.currentState?.waterLevel = 0;
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
              _waterCounter(),
              SizedBox(height: 20),
              _todayHistory(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _bottomNavBar() {
    return Obx(
      () => BottomNavigationBar(
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
      ),
    );
  }

  Container _todayHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          _todayHistoryHeader(),
          Divider(),
          Obx(
            () => waterC.waterTodayHistory.value == null ||
                    waterC.waterTodayHistory.value!.isEmpty
                ? _todayHistoryEmpty()
                : _todayHistoryList(),
          ),
          Obx(() => (waterC.waterTodayHistory.value?.length ?? 0) > 5
              ? _expandHistoryToggleButton()
              : Container()),
          SizedBox(height: 5)
        ],
      ),
    );
  }

  TextButton _expandHistoryToggleButton() {
    return TextButton.icon(
      onPressed: () {
        waterC.isWaterHistoryTodayExpanded.value =
            !waterC.isWaterHistoryTodayExpanded.value;
      },
      style: TextButton.styleFrom(minimumSize: Size(0, 0)),
      icon: Icon(
        waterC.isWaterHistoryTodayExpanded.value
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
        color: Colors.blue,
      ),
      label: Text(
        waterC.isWaterHistoryTodayExpanded.value ? "Show Less" : "Show More",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Column _todayHistoryList() {
    return Column(
      children: [
        waterC.waterTodayHistory.value!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: waterC.isWaterHistoryTodayExpanded.value
                    ? waterC.waterTodayHistory.value!.length
                    : waterC.waterTodayHistory.value!.length > 5
                        ? 5
                        : waterC.waterTodayHistory.value!.length,
                itemBuilder: (context, index) {
                  return _todayHistoryItem(
                      waterC.waterTodayHistory.value![index], index);
                },
              )
            : _todayHistoryEmpty(),
      ],
    );
  }

  Column _todayHistoryItem(item, index) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 8),
          leading: Image.asset(
            item["type"] == "Water"
                ? "assets/glass-of-water.png"
                : beverages
                    .firstWhere((e) => e["name"] == item["type"])["image"]!,
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
                      item["type"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      HelplessUtil.getHourMinuteFromIso8601String(
                          item["datetime"]),
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
                    "${item["amount"].toInt()}mL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: PopupMenuButton(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      elevation: 3,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                      onSelected: (String value) {
                        print('You Click on po up menu item');
                        if (value == 'edit') {
                          bottomSheetFitContentWrapper(
                              context, EditDrinkMain(item: item));
                        } else {
                          waterC.deleteDrinkHistory(
                              waterC.detailWaterToday.value!['id'], item["id"]);
                          AppSnackBar.success('👻👻👻', 'Drink deleted');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        index < waterC.waterTodayHistory.value!.length - 1
            ? Divider(color: Colors.grey.shade300)
            : SizedBox(height: 0),
      ],
    );
  }

  Column _todayHistoryEmpty() {
    return Column(
      children: [
        SizedBox(height: 20),
        SizedBox(
          width: 100,
          child: Image.asset("assets/empty.png"),
        ),
        Container(child: SizedBox(height: 20)),
        Text("You have no history on water intake today."),
        SizedBox(height: 30),
      ],
    );
  }

  Row _todayHistoryHeader() {
    return Row(
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
    );
  }

  Container _waterCounter() {
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
                // child: AspectRatio(
                //   aspectRatio: 0.99,
                //   child: SizedBox(
                //     width: 100,
                //     child: SphericalBottle(
                //       key: waterC.sphereBottleRef,
                //       waterColor: Colors.blue,
                //       bottleColor: Colors.blue,
                //       capColor: Colors.grey.shade700,
                //     ),
                //   ),
                // ),
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
            Obx(() => Text("/${waterC.dailyGoal.value.toInt()}mL",
                style: TextStyle(fontSize: 17))),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => ElevatedButton(
                    onPressed: () => waterC.isDrinking.value
                        ? null
                        : waterC.drink(waterC.selectedCupAmount.value),
                    child: Text(
                      waterC.isDrinking.value
                          ? "Drinking..."
                          : "Drink (${waterC.selectedCupAmount.value.toInt()}mL)",
                      style: TextStyle(
                        color: waterC.isDrinking.value
                            ? Colors.blue
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: waterC.isDrinking.value
                          ? Colors.white
                          : Color(0xFF369FFF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      minimumSize: Size(120, 0),
                      side: waterC.isDrinking.value
                          ? BorderSide(color: Colors.blue)
                          : BorderSide.none,
                      splashFactory: NoSplash.splashFactory,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Stack(
                  children: [
                    IconButton.outlined(
                      onPressed: () => Get.to(() => SwitchCupSize()),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: EdgeInsets.all(12),
                      ),
                      icon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Obx(
                          () => Image.asset(
                            waterC.selectedCupType.value == 'Water'
                                ? "assets/glass-of-water.png"
                                : beverages.firstWhere((e) =>
                                    e["name"] ==
                                    waterC.selectedCupType.value)["image"]!,
                          ),
                        ),
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
