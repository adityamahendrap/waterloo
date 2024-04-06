import 'package:color_log/color_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/constants/beverage_list.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';

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
        Divider(thickness: 0.5),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FullWidthButton(
                type: FullWidthButtonType.secondary,
                text: "Cancel",
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
