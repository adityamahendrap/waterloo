import 'dart:async';

import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_bottle/water_bottle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterloo/app/utils/helpless.dart';

class WaterController extends GetxController {
  final isDrinking = false.obs;
  final dailyGoal = 0.0.obs;
  final currentWater = 0.0.obs; // total mL water drinked today
  final waterLevel = 0.0.obs; // percentage of water in bottle
  final detailWaterToday = Rxn<Map<String, dynamic>>();
  final waterTodayHistory = Rxn<List<Map<String, dynamic>>>();

  final isWaterHistoryTodayExpanded = false.obs;

  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final box = GetStorage();
  CollectionReference waters = FirebaseFirestore.instance.collection('waters');

  void setDailyGoal() {
    final user = box.read("auth");
    dailyGoal.value = user["daily_goal"] ?? 0.0;
  }

  Future<void> fetchWaterToday() async {
    final user = box.read("auth");

    Map<String, DateTime> day =
        HelplessUtil.getStartAndEndOfDay(DateTime.now());

    final watersSnapshot = await waters
        .where("user_id", isEqualTo: user["uid"])
        .where("datetime",
            isGreaterThanOrEqualTo: day['startOfDay'],
            isLessThanOrEqualTo: day['endOfDay'])
        .limit(1)
        .get();

    // null check
    if (watersSnapshot.docs.isNotEmpty) {
      detailWaterToday.value =
          watersSnapshot.docs[0].data() as Map<String, dynamic>;

      clog.debug('detailWaterToday: ${detailWaterToday.value}');

      // separate drinks from detail water data
      waterTodayHistory.value = List<Map<String, dynamic>>.from(
          detailWaterToday.value?["drinks"] ?? []);

      // convert timestamp to datetime string
      for (var drink in waterTodayHistory.value!) {
        drink["datetime"] = HelplessUtil.timestampToIso8601String(
            drink["datetime"] as Timestamp);
      }

      clog.debug('waterTodayHistory: ${waterTodayHistory.value}');

      // calculate total water drinked today
      double tempCurrentWater = 0.0;
      for (var drink in detailWaterToday.value?["drinks"]) {
        tempCurrentWater += drink["amount"];
      }
      currentWater.value = tempCurrentWater;

      clog.debug("totalWaterToday: ${currentWater.value}");

      // update sphere bottle water level UI
      if (currentWater.value >= dailyGoal.value) {
        waterLevel.value = 1;
        sphereBottleRef.currentState?.waterLevel = waterLevel.value;
      } else {
        waterLevel.value = currentWater.value / dailyGoal.value;
        sphereBottleRef.currentState?.waterLevel = waterLevel.value;
      }
    }
  }

  void drinkWater(double amount) async {
    isDrinking.value = true;

    double target = this.waterLevel.value + (amount / this.dailyGoal.value);
    const duration = const Duration(milliseconds: 100);
    Timer? timer;
    timer = Timer.periodic(duration, (Timer t) {
      if (this.waterLevel.value >= 1) {
        this.waterLevel.value = 1;
        timer?.cancel();
        isDrinking.value = false;
      } else if (this.waterLevel.value >= target) {
        timer?.cancel();
        isDrinking.value = false;
      } else {
        this.waterLevel.value += 0.01;
        sphereBottleRef.currentState?.waterLevel = this.waterLevel.value;
      }
    });
    this.currentWater.value += amount;

    final user = box.read("auth");

    Map<String, DateTime> day =
        HelplessUtil.getStartAndEndOfDay(DateTime.now());

    QuerySnapshot<Object?> todayExistingWaterSnapshot = await waters
        .where("user_id", isEqualTo: user["uid"])
        .where("datetime",
            isGreaterThanOrEqualTo: day['startOfDay'],
            isLessThanOrEqualTo: day['endOfDay'])
        .limit(1)
        .get();

    Map<String, dynamic>? todayExistingWater;
    if (todayExistingWaterSnapshot.docs.isNotEmpty) {
      todayExistingWater =
          todayExistingWaterSnapshot.docs[0].data() as Map<String, dynamic>;
    }

    clog.debug("${todayExistingWater}");
    clog.debug("todayExistingWater: $todayExistingWater");

    if (todayExistingWater != null) {
      final DrinkModel drinkModel = DrinkModel(
        amount: amount,
        type: "Water",
        datetime: DateTime.now(),
      );

      todayExistingWater["drinks"].insert(0, drinkModel.toMap());

      await waters
          .doc(todayExistingWaterSnapshot.docs[0].id)
          .update(todayExistingWater)
          .then((value) {
        clog.info("water drinked in the same day");
      }).catchError((error) {
        clog.error("failed to update water: $error");
        throw error;
      });
    } else {
      final WaterModel waterModel = WaterModel(
        userId: user["uid"],
        datetime: DateTime.now(),
        drinks: [
          DrinkModel(
            amount: amount,
            type: "water",
            datetime: DateTime.now(),
          )
        ],
      );
      Map<String, dynamic> waterMap = waterModel.toMap();
      print(waterMap);

      await waters.add(waterMap).then((value) {
        clog.info("new day started, water drinked");
      }).catchError((error) {
        clog.error("failed to add water: $error");
        throw error;
      });
    }

    fetchWaterToday();
  }
}

class DrinkModel {
  late double amount;
  late String type;
  late DateTime datetime;

  DrinkModel({
    required this.amount,
    required this.type,
    required this.datetime,
  });

  DrinkModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    type = json['type'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'datetime': datetime,
    };
  }
}

class WaterModel {
  late String userId;
  late List<DrinkModel> drinks;
  late DateTime datetime;

  WaterModel({
    required this.userId,
    required this.drinks,
    required this.datetime,
  });

  WaterModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    drinks = (json['drinks'] as List)
        .map((e) => DrinkModel(
              amount: e['amount'],
              type: e['type'],
              datetime: e['datetime'],
            ))
        .toList();
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'drinks': drinks.map((e) => e.toMap()).toList(),
      'datetime': datetime,
    };
  }
}
