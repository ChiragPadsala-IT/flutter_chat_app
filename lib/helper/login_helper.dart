import 'package:chat_app/modal/user_info.dart';

import '../services/database_method.dart';
import 'package:chat_app/helper/shared_preference.dart';
import 'package:chat_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginHelper {

  static dynamic exception;
  static QuerySnapshot querySnapshot;

  static Future<bool> login({String email,String password}) async {
    ///check email and password of firebase
    if (await auth.signInWithEmailAndPassword(email, password)) {
      ///save login sharedPreference true after successful sign in
      await SharedPreference.saveLoginSharedPreference(true);

      ///save email after successful sign in
      await SharedPreference.saveEmailSharedPreference(email);

      ///get userdata form of querySnapshot
      querySnapshot = await myDatabase.getUserByEmail(email);

      ///save username after successful sign in
      await SharedPreference.saveUsernameSharedPreference(
          await querySnapshot.docs[0].get("username"));

      ///save uid after successful sign in
      await SharedPreference.saveUidSharedPreference(
          await querySnapshot.docs[0].get("uid"));

      return true;
    } else {
      exception = auth.exception.message;
      return false;
    }
  }
}
