import 'package:color_log/color_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';
import 'package:waterloo/app/widgets/list_wheel_input.dart';
import 'package:waterloo/app/widgets/list_wheel_input_stripe.dart';

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
                    onSelectedItemChanged: (index) {},
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
                    onSelectedItemChanged: (index) {},
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
