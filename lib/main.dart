import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/screens/cup_size/switch_cup_size.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:waterloo/app/screens/history/history.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  GetStorage box = GetStorage();

  Widget getInitScreen() {
    final isAuthentificated = box.hasData('auth');

    if (!isAuthentificated) {
      return GetStarted();
    }
    if (isAuthentificated && box.read('auth')['personalization'] == null) {
      return GenderPersonalization();
    }
    return Home();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: getInitScreen(),
    );
  }
}
