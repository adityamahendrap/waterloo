import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:waterloo/app/controllers/base/auth_controller.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:waterloo/app/widgets/loading.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthController()));
  FirebaseFirestore.instance;
  EasyLoading.instance
    ..indicatorWidget = Loading()
    ..loadingStyle = EasyLoadingStyle.light
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      title: 'Waterloo',
      home: GetStarted(),
      builder: EasyLoading.init(),
    );
  }
}
