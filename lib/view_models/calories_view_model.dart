import 'dart:convert';
import 'dart:developer';
import 'package:fitboost/repository/CaloriesRepo.dart';
import 'package:fitboost/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calories_data.dart';

class CalorieViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;

  String userName = '';
  CalorieViewModel() {
    getAlreadyExistingValues();
  }

  void setDefaultValue() {
    calorieStatusIcon = Icons.cancel;
    calorieStatusIconColor = Colors.red;
    notifyListeners();
  }

  Future<void> getAlreadyExistingValues() async {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = jsonDecode(user);
        userName = userMap['name'];
        await setDate();
        await setCaloriesList(date);
        await setProgressBarValue();
        notifyListeners();
      }
    }
  }

  final _myRepo = CaloriesRepo();

  Future<void> fetchCalories() async {
    if (foodEaten.isEmpty) {
      log('please enter the food eaten');
      return;
    }
    dynamic data = await _myRepo.getFoodCalories(foodEaten);
    if (data == -1) {
      Fluttertoast.showToast(
          msg: "Please write correct food name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      setDefaultValue();
    } else {
      log('from view model $data');
      foodCalories = data.toString();
      calorieStatusIcon = Icons.check_circle_outline;
      calorieStatusIconColor = Colors.green;
      notifyListeners();
    }
  }

  double _caloriesTakenValue = 0.0, _totalCaloriesToBurnValue = 0.0;

  double get caloriesTakenValue => _caloriesTakenValue;

  double get totalCaloriesToBurnValue => _totalCaloriesToBurnValue;

  set caloriesTakenValue(double val) {
    _caloriesTakenValue = val;
    notifyListeners();
  }

  set totalCaloriesToBurnValue(double val) {
    _totalCaloriesToBurnValue = val;
    notifyListeners();
  }

  double _progressBarValue = 0.0;

  double getProgressBarValue() => _progressBarValue;

  Future<void> setProgressBarValue() async {
    log('date is $date');
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = jsonDecode(user);
        log('user map is $userMap');
        double totalCaloriesToBurn = calculateUserBMR(userMap["weight"],
            userMap["height"], userMap["age"], userMap["gender"]);
        double caloriesTaken = 0;
        if (userMap['calorieMap'] != null) {
          Map<String, dynamic> calorieMap = userMap['calorieMap'];
          // log('calorie map is $calorieMap');
          if (calorieMap[date] != null) {
            caloriesTaken = double.parse(calorieMap[date].toString());
          }
        }

        String totalCaloriesToBurnString =
            totalCaloriesToBurn.toStringAsFixed(2);
        totalCaloriesToBurn = double.parse(totalCaloriesToBurnString);

        String caloriesTakenString = caloriesTaken.toStringAsFixed(2);
        caloriesTaken = double.parse(caloriesTakenString);

        _progressBarValue = caloriesTaken / totalCaloriesToBurn;
        totalCaloriesToBurnValue = totalCaloriesToBurn;
        caloriesTakenValue = caloriesTaken;
        notifyListeners();
      }
    }
  }

  List<CaloriesData> _caloriesList = [];

  List<CaloriesData> getCaloriesList() {
    return _caloriesList;
  }

  Future<void> setCaloriesList(String date) async {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = jsonDecode(user);
        if (userMap['map'] == null) {
          Map<String, List<dynamic>> map = {};
          List<dynamic> list = [];
          map[date] = list;
          userMap['map'] = map;
        }
        Map<String, dynamic> map = userMap['map'];
        // log('$map');
        if (map[date] != null) {
          _caloriesList.clear();
          List<dynamic> list = map[date];
          for (int i = 0; i < list.length; i += 4) {
            CaloriesData data = CaloriesData(
                id: list[i],
                foodName: list[i + 1],
                foodCalories: list[i + 2],
                mealType: list[i + 3]);
            _caloriesList.add(data);
          }
        } else {
          // log('map of date:- $date is empty');
          _caloriesList.clear();
        }
      }
    }
    notifyListeners();
  }

  void deleteItemFromList(int index) async {
    log('${_caloriesList[index].id} ${_caloriesList[index].foodName} ${_caloriesList[index].foodCalories} ${_caloriesList[index].mealType}');
    await deleteItemFromSharedPreference(index);
    _caloriesList.removeAt(index);
    await setProgressBarValue();
    notifyListeners();
  }

  Future<void> deleteItemFromSharedPreference(int index) async {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = await jsonDecode(user);
        Map<String, dynamic> map = await userMap['map'];
        log('map is $map');
        Map<String, dynamic> calorieMap = await userMap['calorieMap'];
        log('date is $date');
        // log(map[date]);
        double calories = 0;
        List<dynamic> list = map[date];
        log('index is $index');
        String id = _caloriesList[index].id;

        for (int i = 0; i < list.length; i += 4) {
          if (id == list[i]) {
            list.removeAt(i);
            list.removeAt(i);
            calories = list.removeAt(i);
            list.removeAt(i);
            break;
          }
        }
        double value = calorieMap[date];
        calorieMap[date] = value - calories;
        map[date] = list;
        userMap['map'] = map;
        prefs.setString(email, jsonEncode(userMap));
        log('$userMap');
      }
    }
  }

  void addDataToList(CaloriesData data) {
    _caloriesList.add(data);
    notifyListeners();
  }

  void updateDataToList(CaloriesData data) {
    for (int i = 0; i < _caloriesList.length; i++) {
      if (data.id == _caloriesList[i].id) {
        _caloriesList[i] = data;
        break;
      }
    }
    notifyListeners();
  }

  IconData calorieStatusIcon = Icons.cancel;
  Color calorieStatusIconColor = Colors.red;

  String _foodCalories = '0';

  String get foodCalories => _foodCalories;

  set foodCalories(String value) {
    _foodCalories = value;
    log('set method $value');
    notifyListeners();
  }

  String _foodEaten = '';

  String get foodEaten => _foodEaten;

  set foodEaten(String value) {
    _foodEaten = value;
    notifyListeners();
  }

  String _mealDropDown = mealTypeList[0];

  String get mealDropDown => _mealDropDown;

  set mealDropDown(String value) {
    _mealDropDown = value;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();

  String date = 'date';

  Future<void> setDate() async {
    selectedDate = DateTime.now();
    date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      date = DateFormat("dd-MM-yyyy").format(picked);
      await setCaloriesList(date);
      await setProgressBarValue();
      // log(date);
      selectedDate = picked;
    }
  }

  //take user input from bottom sheet
  Future<bool> addUserCalories() async {
    if (_foodEaten.isEmpty) {
      log('food eaten either null or empty');
    } else if (_foodCalories.isEmpty) {
      log('food calories either null or empty');
    } else if (_mealDropDown.isEmpty) {
      log('Home Drop Down either null or empty');
    } else {
      CaloriesData data = CaloriesData(
          id: DateTime.now().toString(),
          foodName: _foodEaten,
          foodCalories: double.parse(_foodCalories),
          mealType: mealDropDown);
      await _storeUserMeal(data);
      await setProgressBarValue();
      _mealDropDown = mealTypeList[0];
      addDataToList(data);
      setDefaultValue();
      foodCalories = '0';
      return true;
    }
    return false;
  }

  Future<void> setInitialValues(CaloriesData data) async {
    log('data is ${data.foodName}');
    log('data is ${data.foodCalories}');
    log('data is ${data.mealType}');

    foodEaten = data.foodName;
    foodCalories = data.foodCalories.toString();
    mealDropDown = data.mealType;
  }

  //take user input from bottom sheet
  Future<bool> updateUserCalories(String id) async {
    if (_foodEaten.isEmpty) {
      log('food eaten either null or empty');
    } else if (_foodCalories.isEmpty) {
      log('food calories either null or empty');
    } else if (_mealDropDown.isEmpty) {
      log('Home Drop Down either null or empty');
    } else {
      CaloriesData data = CaloriesData(
          id: id,
          foodName: _foodEaten,
          foodCalories: double.parse(_foodCalories),
          mealType: mealDropDown);
      await _updateUserMeal(data);
      await setProgressBarValue();
      _mealDropDown = mealTypeList[0];
      updateDataToList(data);
      foodCalories = '0';
      return true;
    }
    return false;
  }

  Future<void> _updateUserMeal(CaloriesData data) async {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = await jsonDecode(user);
        Map<String, dynamic> map = await userMap['map'];

        log(date);
        List<dynamic> list = map[date];

        double oldCalories = 0, newCalories = 0;

        for (int i = 0; i < list.length; i += 4) {
          if (data.id == list[i]) {
            oldCalories = list[i + 2];
            list[i + 1] = data.foodName;
            list[i + 2] = data.foodCalories;
            list[i + 3] = data.mealType;
            newCalories = list[i + 2];
            break;
          }
        }

        Map<String, dynamic> calorieMap = userMap['calorieMap'];

        double calories = double.parse(calorieMap[date].toString()) -
            oldCalories +
            newCalories;
        calorieMap[date] = calories;
        map[date] = list;
        userMap['map'] = map;
        prefs.setString(email, jsonEncode(userMap));
        log('$userMap');
      }
    }
  }

// function to store the user input of meal and its calorie into the shared preferences
  Future<void> _storeUserMeal(CaloriesData data) async {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = jsonDecode(user);
        log('$userMap');

        Map<String, dynamic> calorieMap;
        if (userMap['calorieMap'] == null) {
          calorieMap = {};
        } else {
          calorieMap = userMap['calorieMap'];
        }

        if (calorieMap[date] == null) {
          calorieMap[date] = 0.0;
        }

        double calories = calorieMap[date] ?? 0.0;
        calorieMap[date] = (calories + double.parse(foodCalories));

        userMap['calorieMap'] = calorieMap;

        if (userMap['map'] == null) {
          log("map is null");
          Map<String, List<dynamic>> map = {};
          List<dynamic> list = [];
          list.add(data.id);
          list.add(data.foodName);
          list.add(data.foodCalories);
          list.add(data.mealType);
          map[date] = list;
          userMap['map'] = map;
          log('print the map $userMap');
          prefs.setString(email, jsonEncode(userMap));
        } else {
          log("map is not null");
          Map<String, dynamic> map = userMap['map'];

          if (map[date] == null) {
            List<dynamic> list = [];
            map[date] = list;
          }
          List<dynamic> list = map[date];
          list.add(data.id);
          list.add(data.foodName);
          list.add(data.foodCalories);
          list.add(data.mealType);
          map[date] = list;
          userMap['map'] = map;
          prefs.setString(email, jsonEncode(userMap));

          log('print the map $userMap');
        }
      }
    }
  }
}
