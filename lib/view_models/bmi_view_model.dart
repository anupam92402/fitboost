import 'dart:developer';

import 'package:fitboost/models/food/recipe_model.dart';
import 'package:fitboost/views/food_screen.dart';
import 'package:fitboost/views/recipe_screen.dart';

import 'package:flutter/material.dart';

import '../models/food/meal.dart';
import '../repository/CaloriesRepo.dart';

class BmiViewModel extends ChangeNotifier {
  double _targetCalories = 0.0;

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

    notifyListeners();
  }

  Future<String> fetchRecipe(String id) async {
    Recipe recipe = await _myRepo.fetchRecipe(id);
    return recipe.spoonacularSourceUrl;
  }
}
