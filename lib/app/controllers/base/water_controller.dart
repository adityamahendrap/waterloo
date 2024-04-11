import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_bottle/water_bottle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterloo/app/models/drink_model.dart';
import 'package:waterloo/app/services/water_service.dart';
import 'package:waterloo/app/utils/app_snack_bar.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'dart:developer';

class WaterController extends GetxController {
  final isDrinking = false.obs;
  final currentWater = 0.0.obs; // total mL water drinked today
  final waterLevel = 0.0.obs; // percentage of water in bottle
  final dailyGoal = 0.0.obs;

  final selectedCupType = 'Water'.obs;
  final selectedCupAmount = 200.0.obs;

  final detailWaterToday = Rxn<Map<String, dynamic>>(); // water collection
  final waterTodayHistory =
      Rxn<List<Map<String, dynamic>>>(); // drinks array in water collection
  final isWaterHistoryTodayExpanded = false.obs;

  // this 2 is necessary cz used in liswheelinput widget that need rx value
  final editDrinkHour = 0.obs;
  final editDrinkMinute = 0.obs;

  final sphereBottleRef = GlobalKey<SphericalBottleState>();
  final box = GetStorage();
  CollectionReference waters = FirebaseFirestore.instance.collection('waters');
  final uuid = Uuid();
  final waterService = WaterService();

  void setDailyGoal() {
    final user = box.read("auth");
    dailyGoal.value = user["daily_goal"] ?? 0.0;
  }

  void switchCupSize(double amount, String type) {
    selectedCupType.value = type;
    selectedCupAmount.value = amount;
    clog.debug("selectedCupType: ${selectedCupType.value}");
    clog.debug("selectedCupAmount: ${selectedCupAmount.value}");
  }

  Future<void> fetchTodayDrinkHistory() async {
    final user = box.read("auth");

    final drink = await waterService.getWater(
      datetime: DateTime.now(),
      userId: user["uid"],
    );

    if (drink == null) {
      clog.error('drink not found');
      return;
    }

    detailWaterToday.value = drink;

    // clog.debug('detailWaterToday: ${detailWaterToday.value}');

    // separate drinks from detail water data
    waterTodayHistory.value = List<Map<String, dynamic>>.from(
        detailWaterToday.value?["drinks"] ?? []);

    // convert timestamp to datetime string
    for (var drink in waterTodayHistory.value!) {
      drink["datetime"] =
          HelplessUtil.timestampToIso8601String(drink["datetime"] as Timestamp);
    }

    // clog.debug('waterTodayHistory: ${waterTodayHistory.value}');

    // calculate total water drinked today
    double tempCurrentWater = 0.0;
    for (var drink in detailWaterToday.value?["drinks"]) {
      tempCurrentWater += drink["amount"];
    }
    currentWater.value = tempCurrentWater;

    // clog.debug("totalWaterToday: ${currentWater.value}");
  }

  void updateWaterCounterUI(double bottlePercentage, double waterAmountML) {
    isDrinking.value = true;

    clog.info("target water % in bottle: $bottlePercentage");
    clog.info('target water amount: $waterAmountML');

    double currentPercentage = waterLevel.value;
    bool isDecreasing = bottlePercentage < currentPercentage;

    currentWater.value = waterAmountML;

    const baseDuration = const Duration(milliseconds: 100);
    double distance = (bottlePercentage - currentPercentage).abs();
    int intervals = (distance * 100).ceil();
    Duration intervalDuration = baseDuration * (1 / intervals) * 5;

    clog.info("distance: $distance");
    clog.info("intervals: $intervals");
    clog.info("intervalDuration: $intervalDuration");

    clog.info('log:');

    Timer? timer;
    if (!isDecreasing) {
      clog.info('increasing');
      timer = Timer.periodic(intervalDuration, (Timer t) {
        if (waterLevel.value >= bottlePercentage) {
          timer?.cancel();
          isDrinking.value = false;
        } else {
          waterLevel.value += distance / intervals; // Use the actual distance
          waterLevel.value = waterLevel.value.clamp(0.0, 1.0);
          print(waterLevel.value);
          sphereBottleRef.currentState?.waterLevel = waterLevel.value;
        }
      });
    } else {
      clog.info('decreasing');
      timer = Timer.periodic(intervalDuration, (Timer t) {
        if (waterLevel.value <= bottlePercentage || waterLevel.value <= 0.0) {
          timer?.cancel();
          isDrinking.value = false;
        } else {
          waterLevel.value -= distance / intervals; // Use the actual distance
          waterLevel.value = waterLevel.value.clamp(0.0, 1.0);
          print(waterLevel.value);
          sphereBottleRef.currentState?.waterLevel = waterLevel.value;
        }
      });
    }
  }

  double calculateBottlePercentage(double amount) {
    clog.info("waterLevel ${waterLevel.value}");
    return waterLevel.value + (amount / dailyGoal.value);
  }

  double calculateTotalWaterAmount(double change) {
    clog.info("currentWater: ${currentWater.value}");
    return currentWater.value + change;
  }

  void drink(double amount) async {
    double totalWaterAmount = calculateTotalWaterAmount(amount);
    double percentage = calculateBottlePercentage(amount);
    updateWaterCounterUI(percentage, totalWaterAmount);

    final user = box.read("auth");
    await waterService.addDrink(
      userId: user["uid"],
      amount: amount,
      type: selectedCupType.value,
    );

    fetchTodayDrinkHistory();
  }

  Future<void> deleteDrinkHistory(String waterId, String drinkId) async {
    final deletedDrink = await waterService.deleteDrink(
      waterId: waterId,
      drinkId: drinkId,
    );

    double totalWaterAmount =
        calculateTotalWaterAmount(-(deletedDrink["amount"] as double));
    double percentage =
        calculateBottlePercentage(-(deletedDrink["amount"] as double));
    updateWaterCounterUI(percentage, totalWaterAmount);

    fetchTodayDrinkHistory();
  }

  Future<void> updateDrinkHistory(
    String waterId,
    String drinkId,
    double amount,
    DateTime date,
    int hour,
    int minute,
    String type,
  ) async {
    // await inspect({
    //   'waterId': waterId,
    //   'drinkId': drinkId,
    //   'amount': amount,
    //   'date': date,
    //   'hour': hour,
    //   'minute': minute,
    //   'type': type,
    // });

    final newDatetime = DateTime(date.year, date.month, date.day, hour, minute);
    final DrinkModel drinkModel = DrinkModel(
      id: drinkId,
      amount: amount,
      type: type,
      datetime: newDatetime,
    );
    final drinkMap = drinkModel.toMap();

    final isUpdatedToSameDay =
        HelplessUtil.isSameDate(newDatetime, DateTime.now());

    // check if newdatetime is in the same day
    if (isUpdatedToSameDay) {
      clog.info('updating today history');

      await waterService.updateDrinkToSameDay(
        waterId: waterId,
        drinkId: drinkId,
        drink: drinkMap,
      );

      // increasing or decreasing ??
      final currentAmount = waterTodayHistory.value!
              .firstWhere((element) => element["id"] == drinkId)["amount"]
          as double;
      final isDecreasing = currentAmount > amount;
      if (isDecreasing) amount = -amount;

      double totalWaterAmount = calculateTotalWaterAmount(amount);
      double percentage = calculateBottlePercentage(amount);
      updateWaterCounterUI(percentage, totalWaterAmount);

      fetchTodayDrinkHistory();

      AppSnackBar.success('Info', 'Drink updated');

      return;
    }

    // if newdatetime is not in the same day
    clog.info('updating another day history');
    deleteDrinkHistory(waterId, drinkId);

    final user = box.read("auth");
    await waterService.addDrinkForUpdateDrink(
      userId: user["uid"],
      amount: amount,
      type: type,
      newDatetime: newDatetime,
    );

    AppSnackBar.success('Info', 'Drink updated');
  }
}
