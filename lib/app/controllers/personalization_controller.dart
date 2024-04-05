import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Gender {
  static const String MALE = "Male";
  static const String FEMALE = "Female";
  static const String SECRET = "Secret";
}

class ActivityLevel {
  static const int SEDENTARY = 1;
  static const int LIGHTLY_ACTIVE = 2;
  static const int MODERATELY_ACTIVE = 3;
  static const int VERY_ACTIVE = 4;
}

class Weather {
  static const String HOT = "Hot";
  static const String TEMPERATE = "Temperate";
  static const String COLD = "Cold";
}

class PersonalizationModel {
  late String gender;
  late int tall;
  late int weight;
  late int age;
  late int wakeUpTimeHour;
  late int wakeUpTimeMinute;
  late int goBedTimeHour;
  late int goBedTimeMinute;
  late int activityLevel;
  late String weather;

  PersonalizationModel({
    required this.gender,
    required this.tall,
    required this.weight,
    required this.age,
    required this.wakeUpTimeHour,
    required this.wakeUpTimeMinute,
    required this.goBedTimeHour,
    required this.goBedTimeMinute,
    required this.activityLevel,
    required this.weather,
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'tall': tall,
      'weight': weight,
      'age': age,
      'wake_up_time': {
        'hour': wakeUpTimeHour,
        'minute': wakeUpTimeMinute,
      },
      'go_bed_time': {
        'hour': goBedTimeHour,
        'minute': goBedTimeMinute,
      },
      'activityLevel': activityLevel,
      'weather': weather,
    };
  }
}

class PersonalizationController extends GetxController {
  GetStorage box = GetStorage();

  final gender = "Male".obs;
  final tall = 170.obs;
  final weight = 50.obs;
  final age = 20.obs;
  final wakeUpTimeHour = 0.obs;
  final wakeUpTimeMinute = 0.obs;
  final goBedTimeHour = 0.obs;
  final goBedTimeMinute = 0.obs;
  final activityLevel = 0.obs;
  final weather = "".obs;
  final dailyGoal = 0.0.obs;

  void savePersonalization() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final Map<String, dynamic> user = box.read('auth');

    final personalizationM = PersonalizationModel(
      gender: this.gender.value,
      tall: this.tall.value,
      weight: this.weight.value,
      age: this.age.value,
      goBedTimeHour: this.wakeUpTimeHour.value,
      goBedTimeMinute: this.wakeUpTimeMinute.value,
      wakeUpTimeHour: this.goBedTimeHour.value,
      wakeUpTimeMinute: this.goBedTimeMinute.value,
      activityLevel: this.activityLevel.value,
      weather: this.weather.value,
    );

    final newData = {
      'personalization': personalizationM.toMap(),
      'daily_goal': this.dailyGoal.value,
    };

    users
        .doc(user['uid'])
        .update(newData)
        .then((value) => clog.info("Personalization Updated"))
        .catchError(
            (error) => clog.error("Failed to update personalization: $error"));

    var cachedUser = box.read("auth");
    cachedUser = {...cachedUser, ...newData};
    box.write("auth", cachedUser);
    clog.debug('cached from savePersonalization $cachedUser');
  }

  double calculateWaterIntake() {
    double result;

    switch (this.gender.value) {
      case Gender.MALE:
        result = 88.362 +
            (13.397 * this.weight.value) +
            (4.799 * this.tall.value) -
            (5.677 * this.age.value);
        break;
      default:
        result = 447.593 +
            (9.247 * this.weight.value) +
            (3.098 * this.tall.value) -
            (4.330 * this.age.value);
        break;
    }

    switch (this.activityLevel.value) {
      case ActivityLevel.SEDENTARY:
        result *= 1.2;
        break;
      case ActivityLevel.LIGHTLY_ACTIVE:
        result *= 1.375;
        break;
      case ActivityLevel.MODERATELY_ACTIVE:
        result *= 1.55;
        break;
      case ActivityLevel.VERY_ACTIVE:
        result *= 1.725;
        break;
    }

    switch (this.weather.value) {
      case Weather.HOT:
        result += 500;
        break;
      case Weather.TEMPERATE:
        result += 250;
        break;
      case Weather.COLD:
        result += 0;
        break;
    }

    result = (result / 100).ceil() * 100.0;

    return result;
  }
}
