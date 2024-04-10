import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/models/drink_model.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:uuid/uuid.dart';

class WaterService {
  final uuid = Uuid();
  CollectionReference waters = FirebaseFirestore.instance.collection('waters');

  Future<Map<String, dynamic>?> getWater({
    DateTime? datetime,
    String? userId,
  }) async {
    Map<String, DateTime> day = HelplessUtil.getStartAndEndOfDay(datetime!);

    final snapshot = await waters
        .where("user_id", isEqualTo: userId!)
        .where("datetime",
            isGreaterThanOrEqualTo: day['startOfDay'],
            isLessThanOrEqualTo: day['endOfDay'])
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs[0].data() as Map<String, dynamic>;
    }

    return null;
  }

  Future<void> addDrink({String? userId, double? amount, String? type}) async {
    Map<String, DateTime> day =
        HelplessUtil.getStartAndEndOfDay(DateTime.now());

    QuerySnapshot<Object?> todayExistingWaterSnapshot = await waters
        .where("user_id", isEqualTo: userId)
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

    final DrinkModel drinkModel = DrinkModel(
      id: uuid.v4(),
      amount: amount!,
      type: type!,
      datetime: DateTime.now(),
    );

    // if today's water exists, add drink to it
    if (todayExistingWater != null) {
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

      return;
    }

    // if today's water does not exist, create a new one
    final WaterModel waterModel = WaterModel(
      id: uuid.v4(),
      userId: userId!,
      datetime: DateTime.now(),
      drinks: [drinkModel],
    );
    Map<String, dynamic> waterMap = waterModel.toMap();

    await waters.add(waterMap).then((value) {
      clog.info("new day started, water drinked");
    }).catchError((error) {
      clog.error("failed to add water: $error");
      throw error;
    });
  }

  Future<Map<String, dynamic>> deleteDrink(
      {String? waterId, String? drinkId}) async {
    final snapshot = await waters.where("id", isEqualTo: waterId).get();

    final water = snapshot.docs.first.data() as Map<String, dynamic>;
    final removedDrink =
        water["drinks"].firstWhere((element) => element["id"] == drinkId)
            as Map<String, dynamic>;
    water["drinks"].removeWhere((element) => element["id"] == drinkId);
    waters.doc(snapshot.docs.first.id).update(water);

    return removedDrink;
  }

  Future<void> updateDrinkToSameDay(
      {String? waterId, String? drinkId, Map<String, dynamic>? drink}) async {
    final snapshot = await waters.where("id", isEqualTo: waterId).get();
    final water = snapshot.docs.first.data() as Map<String, dynamic>;
    final drinks = water["drinks"] as List;

    for (var drink in drinks) {
      drink["datetime"] = (drink["datetime"] as Timestamp).toDate();
    }

    final int index = drinks.indexWhere((element) => element["id"] == drinkId);
    drinks[index] = drink;

    clog.info('drinks: $drinks');

    drinks.sort((a, b) => b["datetime"].compareTo(a["datetime"]));

    water["drinks"] = drinks;
    waters.doc(snapshot.docs.first.id).update(water);
  }

  Future<void> addDrinkForUpdateDrink({
    String? userId,
    DateTime? newDatetime,
    double? amount,
    String? type,
  }) async {
    Map<String, DateTime> day = HelplessUtil.getStartAndEndOfDay(newDatetime!);

    QuerySnapshot<Object?> dayExistingWaterSnapshot = await waters
        .where("user_id", isEqualTo: userId)
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
        amount: amount!,
        type: type!,
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
        userId: userId!,
        datetime: newDatetime,
        drinks: [
          DrinkModel(
            id: uuid.v4(),
            amount: amount!,
            type: type!,
            datetime: newDatetime,
          )
        ],
      );
      Map<String, dynamic> waterMap = waterModel.toMap();
      // print(waterMap);

      await waters.add(waterMap).then((value) {
        clog.info("new day started, water drinked");
      }).catchError((error) {
        clog.error("failed to add water: $error");
        throw error;
      });
    }
  }
}
