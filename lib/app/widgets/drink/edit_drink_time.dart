import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/drink/edit_drink_main.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';
import 'package:waterloo/app/widgets/wrapper/bottom_sheet_fit_content_wrapper.dart';

class EditDrinkTime extends StatefulWidget {
  late Map<String, dynamic> item;

  EditDrinkTime({
    super.key,
    required this.item,
  });

  @override
  State<EditDrinkTime> createState() => _EditDrinkTimeState();
}

class _EditDrinkTimeState extends State<EditDrinkTime> {
  final List<int> hours = List<int>.generate(24, (index) => index);
  final List<int> minutes = List<int>.generate(60, (index) => index);
  final waterC = Get.find<WaterController>();

  @override
  void initState() {
    super.initState();
    waterC.editDrinkHour.value =
        HelplessUtil.getHourFromIso8601String(widget.item['datetime']);
    waterC.editDrinkMinute.value =
        HelplessUtil.getMinuteFromIso8601String(widget.item['datetime']);
  }

  void _okButtonOnPressed() {
    Get.back();
    bottomSheetFitContentWrapper(
      context,
      EditDrinkMain(
        item: {
          ...widget.item,
          ...{
            'datetime': HelplessUtil.changeHourMinuteInIso8601String(
                widget.item['datetime'],
                waterC.editDrinkHour.value,
                waterC.editDrinkMinute.value)
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
          "Set Time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 15),
        Divider(thickness: 0.8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListWheelInputStripe(),
                  ListWheelInput(
                    selectedItem: waterC.editDrinkHour,
                    items: hours,
                    onSelectedItemChanged: (index) {
                      waterC.editDrinkHour.value = hours[index];
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListWheelInputStripe(),
                  ListWheelInput(
                    selectedItem: waterC.editDrinkMinute,
                    items: minutes,
                    onSelectedItemChanged: (index) {
                      waterC.editDrinkMinute.value = minutes[index];
                    },
                  ),
                ],
              ),
            ),
          ],
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
