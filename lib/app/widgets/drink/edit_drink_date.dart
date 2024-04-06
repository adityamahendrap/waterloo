import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditDrinkDate extends StatefulWidget {
  late Map<String, dynamic> item;

  EditDrinkDate({
    super.key,
    required this.item,
  });

  @override
  State<EditDrinkDate> createState() => _EditDrinkDateState();
}

class _EditDrinkDateState extends State<EditDrinkDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(height: 4, width: 50, color: Colors.grey.shade300),
        SizedBox(height: 20),
        Text(
          "Set Date",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 15),
        Divider(thickness: 0.8),
        SfDateRangePicker(
          backgroundColor: Colors.white,
          selectionMode: DateRangePickerSelectionMode.single,
          // initialSelectedDate: DateTime.parse(widget.item['date']),
          initialSelectedDate: DateTime.now(),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            clog.info('${args.value}');
          },
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.transparent,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          selectionTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          selectionColor: Colors.blue,
          todayHighlightColor: Colors.blue,
          headerHeight: 50,
        ),
        Divider(thickness: 0.5),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FullWidthButton(
                type: FullWidthButtonType.secondary,
                text: "Back",
                onPressed: () => Get.back(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: FullWidthButton(
                type: FullWidthButtonType.primary,
                text: "OK",
                onPressed: () {
                  clog.error('Unimplemented OK button');
                  Get.back();
                },
              ),
            )
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
