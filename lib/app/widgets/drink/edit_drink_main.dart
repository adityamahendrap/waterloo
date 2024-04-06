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

class EditDrinkMain extends StatefulWidget {
  late Map<String, dynamic> item;

  EditDrinkMain({
    super.key,
    required this.item,
  });

  @override
  State<EditDrinkMain> createState() => _EditDrinkMainState();
}

class _EditDrinkMainState extends State<EditDrinkMain> {
  TextEditingController _amountEditController =
      TextEditingController(text: "200");
  final _keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void dispose() {
    _amountEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _amountEditController.text = widget.item['amount'].toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(height: 4, width: 50, color: Colors.grey.shade300),
        SizedBox(height: 20),
        Text(
          "Edit Drinked ${widget.item['type']}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 20),
        Divider(thickness: 0.8),
        SizedBox(height: 20),
        SizedBox(
          height: 64,
          width: 64,
          child: Image.asset(widget.item['type'] == 'Water'
              ? "assets/glass-of-water.png"
              : beverages.firstWhere(
                  (e) => e["name"] == widget.item["type"])["image"]!),
        ),
        SizedBox(height: 30),
        _amountInput(),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                  elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.grey.shade400, width: 1.0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      HelplessUtil.getDateFromIso8601String(
                          widget.item["datetime"]),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.edit_outlined, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                  elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.grey.shade400, width: 1.0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      HelplessUtil.getHourMinuteFromIso8601String(
                          widget.item["datetime"]),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.edit_outlined, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  // TODO
                  clog.error('Unimplemented OK button');
                  Get.back();
                },
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        _keyboardVisibilityController.isVisible
            ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
            : SizedBox(),
      ],
    );
  }

  TextField _amountInput() {
    return TextField(
      controller: _amountEditController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        height: 1,
      ),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Colors.blue,
      cursorWidth: 7,
      cursorRadius: Radius.circular(20),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        contentPadding:
            EdgeInsets.only(right: 20, top: 30, bottom: 30, left: 60),
        suffix: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("mL",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
        hintText: "100",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
      ),
    );
  }
}
