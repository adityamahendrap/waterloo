import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waterloo/app/screens/get_started.dart';
import 'package:waterloo/app/screens/home.dart';
import 'package:waterloo/app/screens/personalization/1_gender.dart';
import 'package:waterloo/app/utils/helpless.dart';

class AuthController {
  final box = GetStorage();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> checkOrCreateUser(
      UserCredential credential) async {
    clog.debug('checkOrCreateUser');
    DocumentSnapshot<Object?> userSnapshot =
        await users.doc(credential.user!.uid).get();

    if (!userSnapshot.exists) {
      await users
          .doc(credential.user!.uid)
          .set({
            'uid': credential.user?.uid,
            'email': credential.user?.email,
            'name': credential.user?.displayName,
            'photo_url': credential.user?.photoURL,
            'provider': credential.credential?.providerId,
            'personalization': null,
            'daily_goal': null,
            'created_at': FieldValue.serverTimestamp(),
          })
          .then((_) => clog.info("user added"))
          .catchError((error) {
            clog.error("failed to add user: $error");
            throw error;
          });

      userSnapshot = await users.doc(credential.user!.uid).get();
    } else
      clog.info('user exists');

    Map<String, dynamic> user = userSnapshot.data() as Map<String, dynamic>;
    user['created_at'] =
        HelplessUtil.timestampToIso8601String(user['created_at'] as Timestamp);
    clog.info('user data: $user');

    return user;
  }

  void cacheUser(Map<String, dynamic> user) {
    clog.debug("try to cache user");
    box.write('auth', user);
    clog.info('user cached: $user');
  }

  void redirect(Map<String, dynamic> user) {
    if (user['personalization'] == null) {
      clog.info('personalization not set yet');
      Get.offAll(() => GenderPersonalization());
      return;
    }

    clog.info('redirecting to home');
    Get.offAll(() => Home());
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    clog.info('user logged out');
    box.remove('auth');
    clog.info('cache cleared');
    Get.offAll(() => GetStarted());
  }
}
