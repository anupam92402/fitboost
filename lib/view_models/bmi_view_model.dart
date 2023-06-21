import 'dart:developer';
import 'package:fitboost/models/food/recipe_model.dart';
import 'package:flutter/material.dart';
import '../models/food/meal.dart';
import '../repository/CaloriesRepo.dart';
import '../utils/const.dart';

//purpose of this view model are:-
//1- fetch list of food by hitting api
//2-displaying bmi value and status
//3-get url of food for web view
class BmiViewModel extends ChangeNotifier {
  double _targetCalories = 50, bmi = 0, calories = 4000;
  String weight = '', height = '', bmiStatus = 'Normal';
  Color bmiStatusColor = Colors.green;
  final _myRepo = CaloriesRepo();
  List<Meal> list = [];
  bool isDataLoaded = false;
  double get targetCalories => _targetCalories;

  set targetCalories(double newCalories) {
    _targetCalories = newCalories;
    notifyListeners();
  }

  // function to fetch a list of food from the spoonacular api based on the
  // number of calories[targetCalories] selected by the user from slider in bmi screen
  Future<void> fetchUserMeal() async {
    List<Meal> mealList = [];
    try {
      mealList = await _myRepo.generateMealPlan(
        targetCalories: _targetCalories.toInt(),
      );
    } catch (e) {
      log('${BmiViewModel().runtimeType.toString()} error at line 35 is $e');
    }
    list = mealList;
    log('${BmiViewModel().runtimeType.toString()}:- Data is fetched successfully from fetchUserMeal');

    targetCalories = 50;
    await Future.delayed(const Duration(seconds: 1));
    isDataLoaded = true;
    notifyListeners();
  }

  // to get the url of the food tapped by the user and show the user web view using the url
  Future<String> fetchRecipe(String id) async {
    try {
      Recipe recipe = await _myRepo.fetchRecipe(id);
      return recipe.spoonacularSourceUrl;
    } catch (e) {
      log('${BmiViewModel().runtimeType.toString()} error at line 52 is $e');
      rethrow;
    }
  }

  // show user input values like weight, height on bmi screen
  // and change status of bmi value and status etc
  void getAlreadyExistingValue() {
    isDataLoaded = false;
    Map<String, dynamic> userMap = getUserMap();
    weight = userMap['weight'].toString();
    height = userMap['height'].toString();
    calories = calculateUserBMR(userMap["weight"], userMap["height"],
        userMap["age"], userMap["gender"]);
    targetCalories = 50;
    bmi = getBmi(height: double.parse(height), weight: double.parse(weight));

    if (bmi < 18.5) {
      bmiStatus = 'Underweight';
      bmiStatusColor = Colors.blue;
    } else if (bmi < 25) {
      bmiStatus = 'Normal';
      bmiStatusColor = Colors.green;
    } else {
      bmiStatus = 'Overweight';
      bmiStatusColor = Colors.red;
    }
    notifyListeners();
  }
}
