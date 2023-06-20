import 'dart:developer';
import 'package:fitboost/views/bmi_screen.dart';
import 'package:fitboost/views/edit_screen.dart';
import 'package:fitboost/views/login_screen.dart';
import 'package:fitboost/views/steps_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';
import '../views/calories_screen.dart';

// to get the screen when selects from navigation drawer
//floating action bar is visible in calories screen only and in rest screens its invisible
class HomeViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;
  Widget? _currentScreen = const CaloriesScreen();
  bool _visibility = true;
  DrawerSection _currentDrawerItem = DrawerSection.home;

  Widget? getCurrentScreen() {
    return _currentScreen;
  }

  void setCurrentScreen(Widget? screen) {
    _currentScreen = screen;
  }

  bool get visibility => _visibility;

  set visibility(bool val) {
    _visibility = val;
    notifyListeners();
  }

  DrawerSection getCurrentDrawerItem() => _currentDrawerItem;

  void setCurrentDrawerItem(DrawerSection item, BuildContext context) {
    _currentDrawerItem = item;

    switch (_currentDrawerItem) {
      case DrawerSection.home:
        {
          _currentScreen = const CaloriesScreen();
          visibility = true;
          Navigator.pop(context);
          break;
        }
      case DrawerSection.edit:
        {
          _currentScreen = const EditScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.bmi:
        {
          _currentScreen = const BmiScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.steps:
        {
          _currentScreen = const StepsScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.logout:
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false);
          log('${HomeViewModel().runtimeType.toString()} user logout ${prefs.getString(currentUser)}');
          prefs.setString(currentUser, '');
        }
        break;
    }
    notifyListeners();
  }
}
