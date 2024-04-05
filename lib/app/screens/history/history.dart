import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waterloo/app/widgets/main_appbar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';

class DrinkHistory extends StatefulWidget {
  const DrinkHistory({super.key});

  @override
  State<DrinkHistory> createState() => _DrinkHistoryState();
}

class _DrinkHistoryState extends State<DrinkHistory> {
  DateTime now = DateTime.now();

  bool compareDateInDateTime(DateTime dateTime1, DateTime dateTime2) {
    return DateTime(dateTime1.year, dateTime1.month, dateTime1.day) ==
        DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
  }

  @override
  Widget build(BuildContext context) {
    final EasyInfiniteDateTimelineController _controller =
        EasyInfiniteDateTimelineController();

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
              child: EasyDateTimeLine(
                initialDate: DateTime.now(),
                activeColor: Colors.blue.shade50,
                itemBuilder: (context, dayNumber, dayName, monthName, fullDate,
                    isSelected) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color.fromARGB(129, 227, 242, 253)
                              : Colors.white,
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$dayName',
                                style: TextStyle(color: Colors.black)),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: 0.65,
                                      color: Colors.blue,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    Text(
                                      '$dayNumber',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
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
                            color: compareDateInDateTime(now, fullDate)
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                        ),
                      )
                    ],
                  );
                },
                onDateChange: (selectedDate) {
                  //`selectedDate` the new date selected.
                },
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text("Today, 27 March 2024"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
