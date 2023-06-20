import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

//used as a key to store the current login user in shared preference
const String currentUser = 'currentUser';
const usdaApiKey = 'KsMfQMvmsYSsb9muLybXe5psVjSqRy6wao8wT4hA';
//network image for background of container in bmi screen
const networkImageUrl =
    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80';
const spoonacularApiKey = '385a1b488e7a40dc92ed7be63b41df69';
// const SPOONACULAR_API_KEY = '52f021d041744df2bebffa2144382813'; to be used

//types of meal available
final List<String> mealTypeList = [
  'Breakfast',
  'Lunch',
  'Dinner',
  'Others',
];

final List<String> genderList = [
  'male',
  'female',
];

//list of colors for container in calorie screen
final List<Color> colorList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.deepPurple,
  Colors.pink,
  Colors.greenAccent
];

// enum items for navigation drawer
enum DrawerSection { home, edit, bmi, steps, logout }

//Singleton instance of shared preference
class SharedPrefs {
  static late final SharedPreferences instance;
  static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }
}

// regex used for email verification
RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

// regex used for password verification
RegExp passwordRegex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

// method to show toast to user on events/actions
Future<void> showToast(String message) async {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

// Men: BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) – (5.677 x age in years)
// Women: BMR = 447.593 + (9.247 x weight in kg) + (3.098 x height in cm) – (4.330 x age in years)

// function gives the amount of calories user needs to consume on a daily basis
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

// returns the bmi value of the user
double getBmi({required double height, required double weight}) {
  height /= 100;
  return weight / (height * height);
}

// mode available for user to see amount of calories burned
enum ActivityMode { running, brisk, walking }

//based on the user steps and activity mode it estimates the amount of calories burned by user
double getMetValue(
    {required double height,
    required double weight,
    required int steps,
    required ActivityMode mode}) {
  height /= 100;
  List<double> speedList = [0.9, 1.34, 1.79];
  List<double> metList = [2.8, 3.5, 5];
  double stride = 0.414 * height;
  double distance = stride * steps;
  double met, speed, calories;
  switch (mode) {
    case ActivityMode.brisk:
      {
        speed = speedList[1];
        met = metList[1];
      }
      break;
    case ActivityMode.running:
      {
        speed = speedList[2];
        met = metList[2];
      }
      break;
    case ActivityMode.walking:
    default:
      {
        speed = speedList[0];
        met = metList[0];
      }
      break;
  }
  double time = distance / speed;
  calories = (time * met * 3.5 * weight) / (200 * 60);
  return calories;
}

// return the user map ie details of the user if it's not null
Map<String, dynamic> getUserMap() {
  String? email = SharedPrefs.instance.getString(currentUser);
  if (email != null) {
    String? user = SharedPrefs.instance.getString(email);
    if (user != null) {
      Map<String, dynamic> userMap = jsonDecode(user);
      return userMap;
    }
  }
  throw ErrorDescription("map is null");
}
