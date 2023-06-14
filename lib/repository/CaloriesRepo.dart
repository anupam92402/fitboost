import 'dart:developer';
import '../data/remote/NetworkApiService.dart';
import '../models/food/meal.dart';
import '../models/food/recipe_model.dart';

class CaloriesRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future<dynamic> getFoodCalories(String url) async {
    try {
      dynamic response = await _apiService.getResponse(url);
      log("data in repo class is:- $response");
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Meal>> generateMealPlan({required int targetCalories}) async {
    try {
      List<Meal> response =
          await _apiService.generateMealPlan(maxCalories: targetCalories);
      log("data in repo class is:- ${response[0]}");
      return response;
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  Future<Recipe> fetchRecipe(String id) async {
    try {
      Recipe response = await _apiService.fetchRecipe(id);
      log("data in repo class is:- ${response.spoonacularSourceUrl}");
      return response;
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }
}
