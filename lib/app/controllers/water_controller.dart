import 'dart:async';

import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_bottle/water_bottle.dart';

class WaterController extends GetxController {
  final dailyGoal = 0.0.obs;
  final currentWater = 0.0.obs;
  final waterLevel = 0.0.obs;

  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final box = GetStorage();

  void setDailyGoal() {
    final user = box.read("auth");
    dailyGoal.value = user["daily_goal"];
  }

  void drinkWater(double amount) {
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
  }
}
