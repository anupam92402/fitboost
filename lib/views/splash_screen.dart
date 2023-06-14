import 'dart:async';
import 'dart:developer';
import 'package:fitboost/views/home_screen.dart';
import 'package:fitboost/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prefs = SharedPrefs.instance;
  bool userAlreadyLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkUserAlreadyLoggedIn();
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              userAlreadyLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
      ),
    );
  }

  void checkUserAlreadyLoggedIn() async {
    userAlreadyLoggedIn = false;
    if (prefs.getString(currentUser) != null &&
        prefs.getString(currentUser) != '') {
      userAlreadyLoggedIn = true;
      log('current user logged in is ${prefs.getString(currentUser)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          FlutterLogo(size: MediaQuery.of(context).size.height),
        ],
      ),
    );
  }
}
