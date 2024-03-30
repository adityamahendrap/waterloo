import 'dart:async';
import 'dart:math';

import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_bottle/water_bottle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterloo/app/utils/helpless.dart';

class DrinkModel {
  late double amount;
  late String type;
  late DateTime datetime;

  DrinkModel({
    required this.amount,
    required this.type,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'datetime': datetime,
    };
  }
}

class WaterModel {
  late String user_id;
  late List<DrinkModel> drinks;
  late DateTime datetime;

  WaterModel({
    required this.user_id,
    required this.drinks,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'drinks': drinks.map((e) => e.toMap()).toList(),
      'datetime': datetime,
    };
  }
}

class WaterController extends GetxController {
  final dailyGoal = 0.0.obs;
  final currentWater = 0.0.obs;
  final waterLevel = 0.0.obs;

  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final box = GetStorage();
  CollectionReference waters = FirebaseFirestore.instance.collection('waters');

  void setDailyGoal() {
    final user = box.read("auth");
    dailyGoal.value = user["daily_goal"];
  }

  void drinkWater(double amount) async {
    double target = this.waterLevel.value + (amount / this.dailyGoal.value);
    const duration = const Duration(milliseconds: 100);
    Timer? timer;
    timer = Timer.periodic(duration, (Timer t) {
      if (this.waterLevel.value >= 1) {
        this.waterLevel.value = 1;
        timer?.cancel();
      } else if (this.waterLevel.value >= target) {
        timer?.cancel();
      } else {
        this.waterLevel.value += 0.01;
        sphereBottleRef.currentState?.waterLevel = this.waterLevel.value;
      }
    });
    this.currentWater.value += amount;

    final user = box.read("auth");

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    clog.debug("now: $now");
    clog.debug("startOfDay: $startOfDay");
    clog.debug("endOfDay: $endOfDay");

    QuerySnapshot<Object?> todayExistingWaterSnapshot = await waters
        .where("user_id", isEqualTo: user["uid"])
        .where("datetime",
            isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
        .limit(1)
        .get();

    Map<String, dynamic>? todayExistingWater;
    if (todayExistingWaterSnapshot.docs.isNotEmpty) {
      todayExistingWater =
          todayExistingWaterSnapshot.docs[0].data() as Map<String, dynamic>;
    }

    clog.debug("${todayExistingWater}");
    clog.debug("todayExistingWaters: $todayExistingWater");

    if (todayExistingWater != null) {
      final DrinkModel drinkModel = DrinkModel(
        amount: amount,
        type: "water",
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
        user_id: user["uid"],
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
  }
}
