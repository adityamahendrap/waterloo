import 'package:flutter/material.dart';
import 'package:waterloo/app/widgets/history/basic_item.dart';

class BasicList extends StatelessWidget {
  final List items;

  BasicList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        items.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return BasicItem(item: items[index], index: index);
                },
              )
            : _empty(),
      ],
    );
  }

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: Image.asset("assets/empty.png"),
          ),
          Container(child: SizedBox(height: 20)),
          Text("You have no history on water intake in this day.",
              textAlign: TextAlign.center),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
