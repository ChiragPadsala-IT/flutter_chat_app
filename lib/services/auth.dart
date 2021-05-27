import 'package:chat_app/helper/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthException exception;
  User user;

  ///named constructor
  AuthMethods._();

  ///signUp method
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      return true;
    } on FirebaseException catch (e) {
      exception = e;
      return false;
    }
  }

  ///sign in method
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      return true;
    } on FirebaseAuthException catch (e) {
      exception = e;
      return false;
    }
  }

  /// sign out method
  Future signOut() async {
    removeData() {
      SharedPreference.saveLoginSharedPreference(false);
      SharedPreference.saveEmailSharedPreference("");
      SharedPreference.saveUidSharedPreference("");
      user = null;
      exception = null;
    }

    try {
      if(user != null){
        await _auth.signOut();
        return true;
      }else{
        removeData();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}

AuthMethods auth = AuthMethods._();
