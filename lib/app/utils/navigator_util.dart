import 'package:flutter/material.dart';

class NavigatorUtil {
  static push(BuildContext context, Widget screen, bool withReplacement) {
    withReplacement
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
  }
}
