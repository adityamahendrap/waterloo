import 'package:cloud_firestore/cloud_firestore.dart';
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

class PersonalizationController extends GetxController {
  GetStorage box = GetStorage();

  final gender = "Male".obs;
  final tall = 170.obs;
  final weight = 50.obs;
  final age = 20.obs;
  final wake_up_time_hour = 0.obs;
  final wake_up_time_minute = 0.obs;
  final go_bed_time_hour = 0.obs;
  final go_bed_time_minute = 0.obs;
  final activity_level = 0.obs;
  final weather = "".obs;
  final dailyGoal = 0.0.obs;

  void setGender(String value) => gender.value = value;
  void setTall(int value) => tall.value = value;
  void setWeight(int value) => weight.value = value;
  void setAge(int value) => age.value = value;
  void setActivityLevel(int value) => activity_level.value = value;
  void setWeather(String value) => weather.value = value;
  void setWakeUpTimeHour(int value) => wake_up_time_hour.value = value;
  void setWakeUpTimeMinute(int value) => wake_up_time_minute.value = value;
  void setGoBedTimeHour(int value) => go_bed_time_hour.value = value;
  void setGoBedTimeMinute(int value) => go_bed_time_minute.value = value;
  void setDailyGoal(double value) => dailyGoal.value = value;

  void savePersonalization() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final Map<String, dynamic> user = box.read('auth');

    users
        .doc(user['uid'])
        .update({
          'personalization': {
            'gender': this.gender.value,
            'tall': this.tall.value,
            'weight': this.weight.value,
            'age': this.age.value,
            'wake_up_time': {
              'hour': this.wake_up_time_hour.value,
              'minute': this.wake_up_time_minute.value,
            },
            'go_bed_time': {
              'hour': this.go_bed_time_hour.value,
              'minute': this.go_bed_time_minute.value,
            },
            'activity_level': this.activity_level.value,
            'weather': this.weather.value,
          }
        })
        .then((value) => print("Personalization Updated"))
        .catchError(
            (error) => print("Failed to update personalization: $error"));
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

    switch (this.activity_level.value) {
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
