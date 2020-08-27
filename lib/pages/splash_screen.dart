import 'package:flutter/material.dart';
import 'package:kfb/pages/account_landing.dart';
import 'package:kfb/pages/landing.dart';
import 'package:kfb/shared_pref.dart/sp_auth.dart';
import 'package:kfb/utils/util.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Util _util;
set(s) {
  _util = s;
}

Util get appUtil => _util;

class _SplashScreenState extends State<SplashScreen> {
  bool hasToken = false;
  Util util;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    util = await Util.instance;
    hasToken = await authCheck();
    Future.delayed(
        Duration(
          milliseconds: 3200,
        ), () {
      Navigator.push(
        context,
        // Give login Logic
        MaterialPageRoute(
          // builder: (context) => LandingPage(),
          builder: (context) => hasToken ? LandingPage() : AccountLandingPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/splash_screen_new.gif",
          height: 500,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
