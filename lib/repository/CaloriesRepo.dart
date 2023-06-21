import 'dart:developer';
import '../data/remote/NetworkApiService.dart';
import '../models/food/meal.dart';
import '../models/food/recipe_model.dart';

class CaloriesRepo {
  final NetworkApiService _apiService = NetworkApiService.instance;

  Future<int> getFoodCalories(String url) async {
    int response = -1;
    try {
      int response = await _apiService.getResponse(url);
      log("data in repo class is:- $response");
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<List<Meal>> generateMealPlan({required int targetCalories}) async {
    try {
      List<Meal> response =
          await _apiService.generateMealPlan(maxCalories: targetCalories);
      log("data in repo class is:- ${response[0]}");
      return response;
    } catch (e) {
      log('${CaloriesRepo().runtimeType.toString()} error at line 28 is $e');
      rethrow;
    }
  }

  Future<Recipe> fetchRecipe(String id) async {
    try {
      Recipe response = await _apiService.fetchRecipe(id);
      log("data in repo class is:- ${response.spoonacularSourceUrl}");
      return response;
    } catch (e) {
      log('${CaloriesRepo().runtimeType.toString()} error at line 39 is $e');
      rethrow;
    }
  }
}
