import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:waterloo/app/constants/beverage_list.dart';
import 'package:waterloo/app/constants/cup_size_list.dart';
import 'package:waterloo/app/controllers/base/water_controller.dart';
import 'package:waterloo/app/widgets/full_width_button.dart';

class SwitchCupSize extends StatelessWidget {
  SwitchCupSize({super.key});

  final waterC = Get.find<WaterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          "Switch Cup Size",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _waterCupSizeList(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Or Drink"),
            ),
            _beverageList(context),
          ],
        ),
      ),
    );
  }

  GridView _waterCupSizeList(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 4,
      childAspectRatio: 1 / 1.2,
      children: [
        ...cupSizes.map((cupSize) {
          return _Item(
            text: "${cupSize["amount"]} mL",
            image: cupSize["image"] as String,
            onPressed: () {
              waterC.switchCupSize(
                (cupSize["amount"] as int).toDouble(),
                'Water',
              );
              Get.back();
            },
          );
        }).toList(),
        _Item(
          text: 'Add New',
          icon: Icons.add,
          onPressed: () =>
              _bottomSheet(context, 'Water', 'assets/glass-of-water.png'),
        ),
      ],
    );
  }

  GridView _beverageList(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 4,
      childAspectRatio: 1 / 1.2,
      children: beverages
          .map((beverage) => _Item(
                text: beverage["name"] as String,
                image: beverage["image"] as String,
                onPressed: () => _bottomSheet(
                  context,
                  beverage["name"] as String,
                  beverage["image"] as String,
                ),
              ))
          .toList(),
    );
  }

  Future<dynamic> _bottomSheet(
      BuildContext context, String type, String image) {
    return showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(height: 4, width: 50, color: Colors.grey.shade300),
              SizedBox(height: 20),
              Text("Drinking $type",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 20),
              Divider(thickness: 0.5),
              SizedBox(height: 30),
              SizedBox(
                height: 64,
                width: 64,
                child: Image.asset(image),
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade50,
                  hintText: "Enter the amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade50),
                  ),
                ),
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
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: FullWidthButton(
                      type: FullWidthButtonType.primary,
                      text: "OK",
                      onPressed: () {},
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  final String? image;
  final IconData? icon;
  final Function()? onPressed;

  _Item({
    required this.text,
    this.image,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          padding: EdgeInsets.all(18),
          icon: image != null
              ? Image.asset(
                  image!,
                  width: 32,
                  height: 32,
                )
              : Icon(
                  icon!,
                  size: 32,
                  color: Colors.blue.shade300,
                ),
          iconSize: 24,
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          onPressed: this.onPressed,
        ),
        SizedBox(height: 10),
        Expanded(
          child: Text(
            this.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
