import 'package:flutter/material.dart';

class ListWheelInput extends StatelessWidget {
  const ListWheelInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListWheelScrollView(
        itemExtent: 70,
        perspective: 0.004,
        diameterRatio: 2,
        physics: FixedExtentScrollPhysics(),
        children: List.generate(
          100,
          (index) {
            return Center(
              child: Text(
                "${index + 100}",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}