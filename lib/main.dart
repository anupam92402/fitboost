import 'dart:io';
import 'package:fitboost/utils/const.dart';
import 'package:fitboost/view_models/bmi_view_model.dart';
import 'package:fitboost/view_models/calories_view_model.dart';
import 'package:fitboost/view_models/edit_view_model.dart';
import 'package:fitboost/view_models/home_view_model.dart';
import 'package:fitboost/view_models/login_view_model.dart';
import 'package:fitboost/view_models/register_view_model.dart';
import 'package:fitboost/view_models/user_info_view_model.dart';
import 'package:fitboost/views/onboarding_screen.dart';
import 'package:fitboost/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPrefs instance.
  await SharedPrefs.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // SharedPreferences prefs = SharedPrefs.instance;
  // bool userAlreadyLoggedIn = false;
  @override
  void initState() {
    // checkUserAlreadyLoggedIn();
    super.initState();
  }

  // void checkUserAlreadyLoggedIn() async {
  //   userAlreadyLoggedIn = false;
  //   if (prefs.getString(currentUser) != null &&
  //       prefs.getString(currentUser) != '') {
  //     userAlreadyLoggedIn = true;
  //     log('current user logged in is ${prefs.getString(currentUser)}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UserInfoViewModel()),
        ChangeNotifierProvider(create: (_) => EditViewModel()),
        ChangeNotifierProvider(create: (_) => BmiViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: UserInfoScreen(),
        home: OnBoardingScreen(),
        // home: SplashScreen(),
      ),
    );
  }
}

//
