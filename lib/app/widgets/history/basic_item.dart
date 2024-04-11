import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/constants/beverage_list.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/controllers/history_controller.dart';
import 'package:waterloo/app/utils/helpless.dart';
import 'package:waterloo/app/widgets/drink/edit_drink_main.dart';
import 'package:waterloo/app/widgets/wrapper/bottom_sheet_fit_content_wrapper.dart';

class BasicItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  final waterC = Get.put(WaterController());
  final historyC = Get.find<HistoryController>();

  BasicItem({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 8),
          leading: Image.asset(
            item["type"] == "Water"
                ? "assets/glass-of-water.png"
                : beverages
                    .firstWhere((e) => e["name"] == item["type"])["image"]!,
            width: 32,
            height: 32,
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["type"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      HelplessUtil.getHourMinuteFromIso8601String(
                          item["datetime"]),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  Text(
                    "${item["amount"].toInt()}mL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: PopupMenuButton(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      elevation: 3,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                      onSelected: (String value) async {
                        print('You Click on po up menu item');
                        if (value == 'edit') {
                          bottomSheetFitContentWrapper(
                              context,
                              EditDrinkMain(
                                item: item,
                                isFromHistoryScreen: true,
                              ));
                        } else {
                          await waterC.deleteDrinkHistory(
                              historyC.waterId.value, item["id"]);
                          await historyC.fetchDrinkHistory();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        index < historyC.drinks.length - 1
            ? Divider(color: Colors.grey.shade300)
            : SizedBox(height: 0),
      ],
    );
  }
}
