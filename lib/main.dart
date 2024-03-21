import 'package:flutter/material.dart';
import 'app/screens/get_started.dart';
import 'app/widgets/list_wheel_scroll.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: GetStarted(),
      home: GetStarted(),
    );
  }
}
