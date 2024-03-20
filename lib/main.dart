import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/screens/sign_in.dart';
import 'package:waterloo/app/screens/walkthrough/walkthrough_1.dart';
import 'app/screens/get_started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetStarted(),
    );
  }
}
