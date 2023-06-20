import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fitboost/data/remote/AppException.dart';
import 'package:http/http.dart' as http;
import '../../models/food/meal.dart';
import '../../models/food/recipe_model.dart';
import '../../utils/const.dart';

class NetworkApiService {
  final String _usdaBaseUrl =
      'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=$usdaApiKey&query=';

  final String _spoonacularBaseUrl = 'api.spoonacular.com';

  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      log('message is $url');
      final response = await http.get(Uri.parse(_usdaBaseUrl + url));
      responseJson = returnResponse(response);
      log(' data class $responseJson');
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic>? list = responseJson['foods'];

        if (list != null && list.isNotEmpty) {
          final firstFood = responseJson['foods'][0];
          final calories = firstFood['foodNutrients'].firstWhere(
              (nutrient) => nutrient['nutrientId'] == 1008)['value'];
          return calories.round();
        }
        return -1;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }

  //We create async function to generate meal plan which takes in
  //timeFrame, targetCalories, diet and apiKey

  //If diet is none, we set the diet into an empty string

  //timeFrame parameter sets our meals into 3 meals, which are daily meals.
  //that's why it's set to day

  Future<List<Meal>> generateMealPlan({required int maxCalories}) async {
    //check if diet is null

    Map<String, String> parameters = {
      'number': '30',
      'maxCalories': maxCalories.toString(),
      'apiKey': spoonacularApiKey,
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters

    Uri uri = Uri.https(
      _spoonacularBaseUrl,
      'recipes/findByNutrients',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    /*
    Our try catch uses http.get to retrieve response.
    It then decodes the body of the response into a map,
    and converts the map into a mealPlan object
    by using the factory constructor MealPlan.fromMap
    */
    log(maxCalories.toString());
    try {
      //http.get to retrieve the response
      var response = await http.get(uri, headers: headers);
      log(response.body);
      //decode the body of the response into a map
      List<dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      List<Meal> mealList = [];
      for (int i = 0; i < data.length; i++) {
        Meal meal = Meal.fromMap(data[i]);
        mealList.add(meal);
      }
      return mealList;
    } catch (err) {
      //If our response has error, we throw an error message
      log('error occurred');
      throw err.toString();
    }
  }

  //the fetchRecipe takes in the id of the recipe we want to get the info for
  //We also specify in the parameters that we don't want to include the nutritional
  //information
  //We also parse in our API key
  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': spoonacularApiKey,
    };

    //we call in our recipe id in the Uri, and parse in our parameters
    Uri uri = Uri.https(
      _spoonacularBaseUrl,
      '/recipes/$id/information',
      parameters,
    );

    //And also specify that we want our header to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //finally, we put our response in a try catch block
    try {
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      Recipe recipe = Recipe.fromMap(data);
      return recipe;
    } catch (err) {
      throw err.toString();
    }
  }
}
