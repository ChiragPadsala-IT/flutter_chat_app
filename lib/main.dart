import 'package:chat_app/helper/shared_preference.dart';
import 'package:chat_app/modal/user_info.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/conversaton_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  await SharedPreference.initPreference();
  await UserInfo.saveUserData();
  bool isLogin =
      await SharedPreference.getLoginSharedPreference() == true ? true : false;
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatefulWidget {
  bool isLogin;

  MyApp({this.isLogin = false});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.blueGrey,
        brightness: Brightness.dark,
        fontFamily: "Langar",
        primaryColor: Colors.purple,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.blueGrey,
          contentTextStyle: TextStyle(fontFamily: "Langar"),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(CupertinoColors.systemPurple),
          ),
        ),
      ),
      initialRoute: "/splash_screen",
      routes: {
        "/": (context) => HomeScreen(),
        "/login_screen": (context) => LoginScreen(),
        "/sign_up_screen": (context) => SignUpScreen(),
        "/search_screen": (context) => SearchScreen(),
        "/conversation_screen": (context) => ConversationScreen(),
        "/splash_screen": (context) => SplashScreen(isLogin: widget.isLogin),
      },
    );
  }
}
