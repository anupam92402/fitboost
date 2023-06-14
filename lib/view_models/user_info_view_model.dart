import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fitboost/views/home_screen.dart';
import 'package:fitboost/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class UserInfoViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;

  String? _weight, _height, _age, _gender;

  String? get weight => _weight;

  set weight(weight) {
    _weight = weight;
    notifyListeners();
  }

  String? get height => _height;

  set height(height) {
    _height = height;
    notifyListeners();
  }

  String? get age => _age;

  set age(age) {
    _age = age;
    notifyListeners();
  }

  String? get gender => _gender;

  set gender(gender) {
    _gender = gender;
    notifyListeners();
  }

  File? imageFile;
  getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> submitUserInfo(BuildContext context) async {
    if (_weight == null || _weight?.length == 0) {
      log(' weight either null ');
    } else if (_height == null || _height?.length == 0) {
      log('height either null ');
    } else if (_age == null || _age?.length == 0) {
      log('age either null ');
    } else if (_gender == null) {
      log('name either null or empty');
    } else {
      String? email = prefs.getString(currentUser);
      Map<String, dynamic> userMap = jsonDecode(prefs.getString(email!)!);
      userMap['age'] = double.parse(_age!);
      userMap['weight'] = double.parse(_weight!);
      userMap['height'] = double.parse(_height!);
      userMap['gender'] = _gender;
      if (imageFile != null) {
        userMap['image'] = imageFile?.path;
      }
      prefs.setString(email, jsonEncode(userMap));
      log('user is: $userMap');

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
      Fluttertoast.showToast(
          msg: "User Info Submitted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 16.0);
      log('user info submitted successfully');
    }
  }
}
