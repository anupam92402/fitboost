import 'dart:developer';

import 'package:fitboost/main.dart';
import 'package:fitboost/views/bmi_screen.dart';
import 'package:fitboost/views/edit_screen.dart';
import 'package:fitboost/views/steps_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';
import '../views/calories_screen.dart';

class HomeViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;

  Widget? _currentScreen = CaloriesScreen();

  Widget? getCurrentScreen() {
    return _currentScreen;
  }

  void setCurrentScreen(Widget? screen) {
    _currentScreen = screen;
  }

  bool _visibility = true;

  bool get visibility => _visibility;

  set visibility(bool val) {
    _visibility = val;
    notifyListeners();
  }

  DrawerSection _currentDrawerItem = DrawerSection.home;

  DrawerSection getCurrentDrawerItem() => _currentDrawerItem;

  void setCurrentDrawerItem(DrawerSection item, BuildContext context) {
    _currentDrawerItem = item;

    switch (_currentDrawerItem) {
      case DrawerSection.home:
        {
          _currentScreen = CaloriesScreen();
          visibility = true;
          Navigator.pop(context);
          break;
        }
      case DrawerSection.edit:
        {
          _currentScreen = EditScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.bmi:
        {
          _currentScreen = BmiScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.steps:
        {
          _currentScreen = StepsScreen();
          visibility = false;
          Navigator.pop(context);
        }
        break;

      case DrawerSection.logout:
        {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyApp()),
              (Route<dynamic> route) => false);
          prefs.setString(currentUser, '');
          log('user logout ${prefs.getString(currentUser)}');
        }
        break;
    }
    notifyListeners();
  }
}
