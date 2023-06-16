import 'dart:convert';
import 'dart:developer';

import 'package:fitboost/models/food/recipe_model.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food/meal.dart';
import '../repository/CaloriesRepo.dart';
import '../utils/const.dart';

class BmiViewModel extends ChangeNotifier {
  double _targetCalories = 300;

  double get targetCalories => _targetCalories;

  set targetCalories(double newCalories) {
    _targetCalories = newCalories;
    notifyListeners();
  }

  String _diet = 'None';

  String get diet => _diet;

  set diet(String newDiet) {
    _diet = newDiet;
    notifyListeners();
  }

  final _myRepo = CaloriesRepo();

  List<Meal> list = [];

  Future<void> fetchUserMeal() async {
    List<Meal> mealList = await _myRepo.generateMealPlan(
      targetCalories: _targetCalories.toInt(),
    );
    list = mealList;
    log('fetched');
    log(mealList[0].title);
    targetCalories = 300;
    notifyListeners();
  }

  Future<String> fetchRecipe(String id) async {
    Recipe recipe = await _myRepo.fetchRecipe(id);
    return recipe.spoonacularSourceUrl;
  }

  String weight = '', height = '';
  double bmi = 0, calories = 0;
  String bmiStatus = 'Normal';
  Color bmiStatusColor = Colors.green;

  Future<void> getAlreadyExistingValue() async {
    SharedPreferences prefs = SharedPrefs.instance;
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = await jsonDecode(user);
        weight = userMap['weight'].toString();
        height = userMap['height'].toString();
        targetCalories = 300;
        bmi =
            getBmi(height: double.parse(height), weight: double.parse(weight));

        if (bmi < 18.5) {
          bmiStatus = 'Underweight';
          bmiStatusColor = Colors.yellow;
        } else if (bmi < 25) {
          bmiStatus = 'Normal';
          bmiStatusColor = Colors.green;
        } else {
          bmiStatus = 'Overweight';
          bmiStatusColor = Colors.red;
        }

        calories = calculateUserBMR(userMap["weight"], userMap["height"],
            userMap["age"], userMap["gender"]);
      }
    }
    notifyListeners();
  }
}
