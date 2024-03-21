// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:waterloo/app/widgets/text_title.dart';

class ListWheelScroll extends StatefulWidget {
  const ListWheelScroll({Key? key}) : super(key: key);

  @override
  _ListWheelScrollState createState() => _ListWheelScrollState();
}

class _ListWheelScrollState extends State<ListWheelScroll> {
  late FixedExtentScrollController _controller;
  int _selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 120, top: 12),
            child: Text(
              "cm",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: ListWheelScrollView.useDelegate(
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedItemIndex = index;
                    });
                  },
                  controller: _controller,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.2,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 13,
                    builder: (context, index) {
                      return Itemns(
                        items: index,
                        isSelected: index == _selectedItemIndex,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Itemns extends StatelessWidget {
  final int items;
  final bool isSelected;

  Itemns({required this.items, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            items.toString(),
            style: TextStyle(
              fontSize: 40,
              color: isSelected ? Colors.blue : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
