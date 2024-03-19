import 'package:flutter/material.dart';

enum FullWidthButtonType { primary, secondary }

class FullWidthButton extends StatelessWidget {
  final FullWidthButtonType type;
  final String text;
  final void Function() onPressed;

  const FullWidthButton({
    Key? key,
    required this.type,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  Color getBgColor() {
    return type == FullWidthButtonType.primary
        ? Color(0xFF369FFF)
        : Color(0xFFEFF7FF);
  }

  Color getFontColor() {
    return type == FullWidthButtonType.primary
        ? Colors.white
        : Color(0xFF369FFF);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Text(
        this.text,
        style: TextStyle(fontWeight: FontWeight.bold, color: getFontColor()),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        shape: StadiumBorder(),
        backgroundColor: getBgColor(),
        elevation: 0,
      ),
    );
  }
}