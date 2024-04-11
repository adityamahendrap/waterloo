import 'package:color_log/color_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:waterloo/app/controllers/history_controller.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/history/basic_item.dart';
import 'package:waterloo/app/widgets/history/basic_list.dart';
import 'package:waterloo/app/widgets/main_appbar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';

class History extends StatelessWidget {
  History({super.key});

  final _historyC = Get.put(HistoryController());
  final _waterC = Get.find<WaterController>();
  DateTime _now = DateTime.now();
  String _currentMonth = '';

  bool _compareDateInDateTime(DateTime dateTime1, DateTime dateTime2) {
    return DateTime(dateTime1.year, dateTime1.month, dateTime1.day) ==
        DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
  }

  double _getWaterPercentage(DateTime fullDate) {
    String key = HelplessUtil.getDateFromDateTime(fullDate);

    if (_historyC.waterAggregate.containsKey(key)) {
      double sum = _historyC.waterAggregate[key]['sum'];
      return sum / _waterC.dailyGoal.value;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: MainAppBar(
        title: "History",
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: _timeline(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    DateFormat('E, d MMMM y')
                        .format(_historyC.selectedDate.value),
                  ),
                ],
              ),
            ),
            _historyList(),
          ],
        ),
      ),
    );
  }

  Container _historyList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Obx(
        () => _historyC.selectedDate.value.isAfter(_now)
            ? Text("This day has'nt come yet.")
            : BasicList(items: _historyC.drinks.toList()),
      ),
    );
  }

  EasyDateTimeLine _timeline() {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      activeColor: Colors.blue.shade50,
      itemBuilder:
          (context, dayNumber, dayName, monthName, fullDate, isSelected) {
        if (monthName != _currentMonth) {
          _currentMonth = monthName;
          print('Month changed to: $_currentMonth');
        }
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromARGB(129, 227, 242, 253)
                    : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$dayName', style: TextStyle(color: Colors.black)),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _getWaterPercentage(fullDate),
                            color: Colors.blue,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          Text(
                            '$dayNumber',
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _compareDateInDateTime(_now, fullDate)
                      ? Colors.blue
                      : Colors.transparent,
                ),
              ),
            )
          ],
        );
      },
      onDateChange: (selectedDate) {
        _historyC.selectedDate.value = selectedDate;
        _historyC.fetchDrinkHistory();
      },
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
      ),
    );
  }
}
