import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/drink/edit_drink_main.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:waterloo/app/widgets/wrapper/bottom_sheet_fit_content_wrapper.dart';

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
  final waterC = Get.find<WaterController>();
  DateTime? tempDate;

  @override
  void initState() {
    waterC.editDrinkDate.value = DateTime.parse(widget.item['datetime']);
    tempDate = waterC.editDrinkDate.value;
    super.initState();
  }

  void _okButtonOnPressed() {
    Get.back();
    bottomSheetFitContentWrapper(
      context,
      EditDrinkMain(
        item: {
          ...widget.item,
          ...{
            'datetime': HelplessUtil.changeDateInIso8601String(
              widget.item['datetime'],
              tempDate!,
            ),
          }
        },
      ),
    );
  }

  void _backButtonOnPressed() {
    Get.back();
    bottomSheetFitContentWrapper(context, EditDrinkMain(item: widget.item));
  }

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
          initialSelectedDate: DateTime.parse(widget.item['datetime']),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            clog.info('${args.value}');
            tempDate = args.value;
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
                onPressed: () => _backButtonOnPressed(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: FullWidthButton(
                type: FullWidthButtonType.primary,
                text: "OK",
                onPressed: () => _okButtonOnPressed(),
              ),
            )
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
