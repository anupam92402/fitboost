import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

///spoonacular api key
///52f021d041744df2bebffa2144382813

enum DrawerSection { home, edit, bmi, steps, logout }

final List<String> mealTypeList = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Others',
];

const USDA_API_KEY = 'KsMfQMvmsYSsb9muLybXe5psVjSqRy6wao8wT4hA';
// const SPOONACULAR_API_KEY = '52f021d041744df2bebffa2144382813'; to be used
const SPOONACULAR_API_KEY = '385a1b488e7a40dc92ed7be63b41df69';
const networkImageUrl =
    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80';

final List<String> genderList = [
  'male',
  'female',
];

final List<Color> colorList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.deepPurple,
  Colors.pink,
  Colors.greenAccent
];

const String currentUser = 'currentUser';

class SharedPrefs {
  static late final SharedPreferences instance;
  static Future<SharedPreferences> init() async {
    instance = await SharedPreferences.getInstance();
    return instance;
  }
}

RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp passwordRegex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

Future<void> showToast(String message) async {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.black,
      fontSize: 16.0);
}

double calculateUserBMR(
    double weight, double height, double age, String gender) {
  double bmr = 0;
  if (gender == 'male') {
    bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
  } else {
    bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
  }
  return bmr;
}

// Men: BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) – (5.677 x age in years)
// Women: BMR = 447.593 + (9.247 x weight in kg) + (3.098 x height in cm) – (4.330 x age in years)
