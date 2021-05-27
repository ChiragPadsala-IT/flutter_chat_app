import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  bool isLogin;

  SplashScreen({this.isLogin});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      widget.isLogin
          ? Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false)
          : Navigator.of(context)
              .pushNamedAndRemoveUntil("/login_screen", (route) => false);
    });
    super.initState();
  }

  final spinKit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/image/splash_screen_image.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            height: MediaQuery.of(context).size.height * 1.5,
            width: MediaQuery.of(context).size.width,
            child: spinKit,
          ),
        ],
      ),
    );
  }
}
