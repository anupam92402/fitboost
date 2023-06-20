import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const.dart';

//purpose of this view model is to get the values stored by user and let the user update it
class EditViewModel extends ChangeNotifier {
  String name = '',
      weight = '',
      height = '',
      age = '',
      _gender = '',
      imagePath = '';

  File? imageFile;

  get gender => _gender == genderList[0] ? genderList[0] : genderList[1];

  set gender(value) {
    _gender = value;
    notifyListeners();
  }

  // function to fetch user inputted details and displaying it
  Future<void> getAlreadyExistingValue() async {
    Map<String, dynamic> userMap = getUserMap();
    log('${EditViewModel().runtimeType.toString()} userMap is $userMap');
    name = userMap['name'];
    weight = userMap['weight'].toString();
    height = userMap['height'].toString();
    age = userMap['age'].toString();
    gender = userMap['gender'];
    if (userMap['image'] != null) {
      imagePath = userMap['image'];
    }
    notifyListeners();
  }

  // image picker to select images from gallery
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

  // function to update user details and show a toast when details get updated
  void updateUserDetails() {
    SharedPreferences prefs = SharedPrefs.instance;
    String? email = prefs.getString(currentUser);

    Map<String, dynamic> userMap = getUserMap();
    userMap['name'] = name;
    userMap['weight'] = double.tryParse(weight);
    userMap['height'] = double.tryParse(height);
    userMap['age'] = double.tryParse(age);
    userMap['gender'] = gender;
    if (imagePath.isNotEmpty) {
      userMap['image'] = imagePath;
      notifyListeners();
    }
    prefs.setString(email ?? 'null email', jsonEncode(userMap));
    log('${EditViewModel().runtimeType.toString()} updated user details are: $userMap');

    showToast("User Details Updated Successfully");
  }
}
