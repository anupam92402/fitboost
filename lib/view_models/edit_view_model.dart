import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

class EditViewModel extends ChangeNotifier {
  Future<void> getAlreadyExistingValue() async {
    SharedPreferences prefs = SharedPrefs.instance;
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = await jsonDecode(user);
        log('userMap is $userMap');
        name = userMap['name'];
        weight = userMap['weight'].toString();
        height = userMap['height'].toString();
        age = userMap['age'].toString();
        gender = userMap['gender'];
        if (userMap['image'] != null) {
          imagePath = userMap['image'];
        }
      }
    }
    notifyListeners();
  }

  String _name = '', _weight = '', _height = '', _age = '', _gender = '';
  String imagePath = '';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  get weight => _weight;

  set weight(value) {
    _weight = value;
    notifyListeners();
  }

  get gender => _gender == genderList[0] ? genderList[0] : genderList[1];

  set gender(value) {
    _gender = value;
    notifyListeners();
  }

  get age => _age;

  set age(value) {
    _age = value;
    notifyListeners();
  }

  get height => _height;

  set height(value) {
    _height = value;
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
      imagePath = imageFile?.path.toString() ?? '';
      notifyListeners();
    }
  }

  void updateUserDetails(BuildContext context) async {
    SharedPreferences prefs = SharedPrefs.instance;
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = await jsonDecode(user);
        userMap['name'] = name;
        userMap['weight'] = double.tryParse(weight);
        userMap['height'] = double.tryParse(height);
        userMap['age'] = double.tryParse(age);
        userMap['gender'] = gender;
        if (imagePath.isNotEmpty) {
          userMap['image'] = imagePath;
          notifyListeners();
        }
        prefs.setString(email, jsonEncode(userMap));
        log('update user is: $userMap');

        Fluttertoast.showToast(
            msg: "User Details Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
