import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListWheelInput extends StatelessWidget {
  final List<int> items;
  final void Function(int) onSelectedItemChanged;
  final RxInt selectedItem;
  final bool? isPaddingNumber;

  const ListWheelInput({
    super.key,
    required this.items,
    required this.onSelectedItemChanged,
    required this.selectedItem,
    this.isPaddingNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 500,
        child: ListWheelScrollView(
          itemExtent: 70,
          perspective: 0.004,
          diameterRatio: 2,
          physics: FixedExtentScrollPhysics(),
          controller: FixedExtentScrollController(
            initialItem: this.items.indexOf(this.selectedItem.value),
          ),
          children: this
              .items
              .map((item) => Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        item.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 40,
                          color: this.selectedItem.value == item
                              ? Colors.blue
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          onSelectedItemChanged: ((value) => this.onSelectedItemChanged(value)),
        ),
      ),
    );
  }
}
