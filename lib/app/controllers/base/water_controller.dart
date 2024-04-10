import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_bottle/water_bottle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    }
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
    // clog.info("totalWaterAmount: $totalWaterAmount");
    // clog.info("percentage: $percentage");
    updateWaterCounterUI(percentage, totalWaterAmount);

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

    // clog.debug("${todayExistingWater}");
    // clog.debug("todayExistingWater: $todayExistingWater");

    if (todayExistingWater != null) {
      final DrinkModel drinkModel = DrinkModel(
        id: uuid.v4(),
        amount: amount,
        type: selectedCupType.value,
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
        id: uuid.v4(),
        userId: user["uid"],
        datetime: DateTime.now(),
        drinks: [
          DrinkModel(
            id: uuid.v4(),
            amount: amount,
            type: selectedCupType.value,
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

    fetchTodayDrinkHistory();
  }

  void deleteDrinkHistory(String waterId, String drinkId) async {
    final snapshot = await waters.where("id", isEqualTo: waterId).get();

    final water = snapshot.docs.first.data() as Map<String, dynamic>;
    final removedDrink =
        water["drinks"].firstWhere((element) => element["id"] == drinkId)
            as Map<String, dynamic>;
    water["drinks"].removeWhere((element) => element["id"] == drinkId);

    waters.doc(snapshot.docs.first.id).update(water);
    // clog.info('drink deleted');

    double totalWaterAmount =
        calculateTotalWaterAmount(-(removedDrink["amount"] as double));
    // clog.info(
    //     "totalWaterAmount: ${-(removedDrink["amount"] as double)}, $totalWaterAmount");
    double percentage =
        calculateBottlePercentage(-(removedDrink["amount"] as double));
    // clog.info(
    //     "percentage: ${-(removedDrink["amount"] as double)}, $percentage");
    updateWaterCounterUI(percentage, totalWaterAmount);

    fetchTodayDrinkHistory();
  }

  Future<void> updateDrinkHistory(String waterId, String drinkId, double amount,
      DateTime date, int hour, int minute, String type) async {
    clog.debug('updateDrinkHistory');
    await inspect({
      'waterId': waterId,
      'drinkId': drinkId,
      'amount': amount,
      'date': date,
      'hour': hour,
      'minute': minute,
      'type': type,
    });

    final newDatetime = DateTime(date.year, date.month, date.day, hour, minute);
    final DrinkModel drinkModel = DrinkModel(
      id: drinkId,
      amount: amount,
      type: type,
      datetime: newDatetime,
    );
    final drinkMap = drinkModel.toMap();

    // check if newdatetime is in the same day
    if (HelplessUtil.isSameDate(newDatetime, DateTime.now())) {
      clog.info('updating today history');

      final snapshot = await waters.where("id", isEqualTo: waterId).get();
      final water = snapshot.docs.first.data() as Map<String, dynamic>;
      final drinks = water["drinks"] as List;

      for (var drink in drinks) {
        drink["datetime"] = (drink["datetime"] as Timestamp).toDate();
      }

      final int index =
          drinks.indexWhere((element) => element["id"] == drinkId);
      drinks[index] = drinkMap;

      clog.info('drinks: $drinks');

      drinks.sort((a, b) => b["datetime"].compareTo(a["datetime"]));

      water["drinks"] = drinks;
      waters.doc(snapshot.docs.first.id).update(water);

      fetchTodayDrinkHistory();
      AppSnackBar.success('Info', 'Drink updated');

      return;
    }

    // if newdatetime is not in the same day
    clog.info('updating another day history');
    this.deleteDrinkHistory(waterId, drinkId);

    final user = box.read("auth");

    Map<String, DateTime> day = HelplessUtil.getStartAndEndOfDay(newDatetime);

    QuerySnapshot<Object?> dayExistingWaterSnapshot = await waters
        .where("user_id", isEqualTo: user["uid"])
        .where("datetime",
            isGreaterThanOrEqualTo: day['startOfDay'],
            isLessThanOrEqualTo: day['endOfDay'])
        .limit(1)
        .get();

    Map<String, dynamic>? dayExistingWater;
    if (dayExistingWaterSnapshot.docs.isNotEmpty) {
      dayExistingWater =
          dayExistingWaterSnapshot.docs[0].data() as Map<String, dynamic>;
    }

    if (dayExistingWater != null) {
      final DrinkModel drinkModel = DrinkModel(
        id: uuid.v4(),
        amount: amount,
        type: type,
        datetime: newDatetime,
      );

      for (var drink in dayExistingWater["drinks"]) {
        drink["datetime"] = (drink["datetime"] as Timestamp).toDate();
      }
      dayExistingWater["drinks"].add(drinkModel.toMap());
      clog.debug("dayExistingWater: $dayExistingWater");

      dayExistingWater["drinks"].sort((a, b) =>
          (b["datetime"] as DateTime).compareTo((a["datetime"] as DateTime)));

      await waters
          .doc(dayExistingWaterSnapshot.docs[0].id)
          .update(dayExistingWater)
          .then((value) {
        clog.info("water drinked in the same day");
      }).catchError((error) {
        clog.error("failed to update water: $error");
        throw error;
      });
    } else {
      final WaterModel waterModel = WaterModel(
        id: uuid.v4(),
        userId: user["uid"],
        datetime: newDatetime,
        drinks: [
          DrinkModel(
            id: uuid.v4(),
            amount: amount,
            type: type,
            datetime: newDatetime,
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

    AppSnackBar.success('Info', 'Drink updated');
  }
}

class DrinkModel {
  late String id;
  late double amount;
  late String type;
  late DateTime datetime;

  DrinkModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.datetime,
  });

  DrinkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    type = json['type'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'datetime': datetime,
    };
  }
}

class WaterModel {
  late String id;
  late String userId;
  late List<DrinkModel> drinks;
  late DateTime datetime;

  WaterModel({
    required this.id,
    required this.userId,
    required this.drinks,
    required this.datetime,
  });

  WaterModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    drinks = (json['drinks'] as List)
        .map((e) => DrinkModel(
              id: e['id'],
              amount: e['amount'],
              type: e['type'],
              datetime: e['datetime'],
            ))
        .toList();
    datetime = json['datetime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'drinks': drinks.map((e) => e.toMap()).toList(),
      'datetime': datetime,
    };
  }
}
