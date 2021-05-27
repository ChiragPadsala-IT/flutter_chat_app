import 'package:chat_app/helper/shared_preference.dart';

class UserInfo{
  static String username;
  static String uid ;
  static String chatRoomId;
  static String email;

  static saveUserData()async{
    username = await SharedPreference.getUsernameSharedPreference();
    uid = await SharedPreference.getUidSharedPreference();
    email = await SharedPreference.getEmailSharedPreference();
  }

}