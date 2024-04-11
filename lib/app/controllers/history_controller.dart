import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waterloo/app/services/water_service.dart';
import 'package:waterloo/app/utils/helpless.dart';

class HistoryController extends GetxController {
  final isLoading = false.obs;
  final selectedDate = DateTime.now().obs;
  final waterId = ''.obs;
  final drinks = [].obs;
  final waterAggregate = {}.obs;

  final waterService = WaterService();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDrinkHistory();
    calculateWaterAggregate(DateTime.now().month);
  }

  Future<void> fetchDrinkHistory() async {
    final user = box.read('auth');

    final water = await waterService.getWater(
      userId: user['uid'],
      datetime: DateTime(selectedDate.value.year, selectedDate.value.month,
          selectedDate.value.day),
    );

    for (var drink in water?['drinks'] ?? []) {
      drink['datetime'] = drink['datetime'].toDate().toString();
    }

    waterId.value = water?['id'] ?? '';
    drinks.value = water?['drinks'] ?? [];
    clog.debug('${drinks}');
  }

  calculateWaterAggregate(int month) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('waters');
    final user = box.read('auth');

    final waters = await ref
        .where('user_id', isEqualTo: user['uid'])
        .where('datetime',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, month, 1),
            isLessThan: DateTime(DateTime.now().year, month + 1, 1))
        .get();

    List<Map<String, dynamic>> temp = [];

    waters.docs.forEach((water) {
      double sum = 0.0;
      water['drinks'].forEach((drink) {
        sum += drink['amount'];
      });
      print('Water ID: ${water.id}, Sum of drinks: $sum');
      temp.add({
        'id': water.id,
        'sum': sum,
        'date':
            HelplessUtil.getDateFromDateTime(water['datetime'].toDate()),
      });
    });

    Map<String, dynamic> result = {};
    temp.forEach((element) {
      result[element['date']] = {
        'id': element['id'],
        'sum': element['sum'],
      };
    });

    waterAggregate.value = result;

    inspect(result);
  }
}
