import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

//input user basic details like weight, age, height etc
class UserInfoViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;
  String? _weight, _height, _age, _gender;
  File? imageFile;

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

  //function to get image from gallery and store it in shared preferences
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

  // save user input values into the shared preferences
  bool submitUserInfo(BuildContext context) {
    if (_weight == null || _weight == '') {
      showToast('Please enter some value for weight');
    } else if (_height == null || _height == '') {
      showToast('Please enter some value for height');
    } else if (_age == null || _age == '') {
      showToast('Please enter some value for age');
    } else if (_gender == null) {
      showToast('Please select the gender');
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
      showToast('User Info Submitted Successfully');
      return true;
    }
    return false;
  }
}
