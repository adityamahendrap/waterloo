import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:intl/intl.dart';

class HelplessUtil {
  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static Map<String, DateTime> getStartAndEndOfDay(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return {
      'startOfDay': startOfDay,
      'endOfDay': endOfDay,
    };
  }

  static String getDateFromDateTime(DateTime dateTime) {
    return DateFormat('y-M-d').format(dateTime);
  }

  static String timestampToIso8601String(Timestamp timestamp) {
    return timestamp.toDate().toIso8601String();
  }

  static String getHourMinuteFromIso8601String(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    return DateFormat.Hm().format(dateTime);
  }

  static int getHourFromIso8601String(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    return dateTime.hour;
  }

  static int getMinuteFromIso8601String(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    return dateTime.minute;
  }

  static changeHourMinuteInIso8601String(
      String iso8601String, int hour, int minute) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    final newDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
        hour, minute, dateTime.second);
    return newDateTime.toIso8601String();
  }

  static changeDateInIso8601String(String iso8601String, DateTime date) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    final newDateTime = DateTime(date.year, date.month, date.day, dateTime.hour,
        dateTime.minute, dateTime.second);
    return newDateTime.toIso8601String();
  }

  static String getDateFromIso8601String(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    // Dec 20, 2021
    return DateFormat.yMMMd().format(dateTime);
  }

  static DateTime iso8601StringToTimestamp(String iso8601String) {
    return DateTime.parse(iso8601String);
  }
}
