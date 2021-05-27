import 'package:flutter/material.dart';

import '../services/database_method.dart';
import 'package:chat_app/helper/shared_preference.dart';
import 'package:chat_app/services/auth.dart';

class SignUpHelper{

  static dynamic exception;

  static Future<bool> SignUp(
      {String username, String email, String password}) async {
    /// sign up with email and password
    if (await auth.signUpWithEmailAndPassword(email, password)) {
      /// store information into database
      if (await myDatabase.uploadUserInfo(username, email,auth.user.uid)) {
        ///save into shared preference
        await SharedPreference.saveLoginSharedPreference(true);
        await SharedPreference.saveEmailSharedPreference(email);
        await SharedPreference.saveUsernameSharedPreference(username);
        await SharedPreference.saveUidSharedPreference(auth.user.uid);
        return true;
      } else {
        exception = myDatabase.exception.message;
        return false;
      }
    }else{
      exception = auth.exception.message;
      return false;
    }
  }
}
