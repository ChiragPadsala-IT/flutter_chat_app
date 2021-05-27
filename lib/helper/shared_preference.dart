import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{

  ///declare instance
  static SharedPreferences _sharedPreferences ;

  ///key for save data
  static String sharedPreferenceLoginKey = "LoginKey";
  static String sharedPreferenceUsernameKey = "UsernameKey";
  static String sharedPreferenceEmailKey = "EmailKey";
  static String sharedPreferenceUidKey = "UidKey";
  static String sharedPreferenceChatRoomKey = "ChatRoomKey";

  ///initialize instance
  static Future initPreference()async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ///save user already logIn or Not
  static Future saveLoginSharedPreference(bool isLogin) async {
    _sharedPreferences.setBool(sharedPreferenceLoginKey, isLogin);
  }

  ///save user Username
  static Future saveUsernameSharedPreference(String username)async{
    _sharedPreferences.setString(sharedPreferenceUsernameKey, username);
  }

  ///save user email
  static Future saveEmailSharedPreference(String email)async{
    _sharedPreferences.setString(sharedPreferenceEmailKey, email);
  }

  ///save user Username Unique Id
  static Future saveUidSharedPreference(String uid)async{
    _sharedPreferences.setString(sharedPreferenceUidKey, uid);
  }

  ///get info for user already login or Not
  static Future getLoginSharedPreference() async {
    return _sharedPreferences.getBool(sharedPreferenceLoginKey);
  }

  ///get user Username if already login
  static Future getUsernameSharedPreference()async{
    return _sharedPreferences.getString(sharedPreferenceUsernameKey);
  }

  ///get user email if already login
  static Future getEmailSharedPreference()async{
    return _sharedPreferences.getString(sharedPreferenceEmailKey);
  }

  ///get user Username Unique Id
  static Future<String> getUidSharedPreference()async{
    return _sharedPreferences.getString(sharedPreferenceUidKey);
  }
}