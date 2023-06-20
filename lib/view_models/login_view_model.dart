import 'dart:convert';
import 'package:fitboost/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// authenticates user and login, move to home page if login is successful
class LoginViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;

  String? _email, _password;

  String? get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  String? get password => _password;

  set password(password) {
    _password = password;
    notifyListeners();
  }

  // function to login user and if successful take user to home screen
  bool loginUser(BuildContext context) {
    if (_email == null || (_email != null && _email!.isEmpty)) {
      showToast('Please enter a valid email id');
    } else if (_password == null || (_password != null && _password!.isEmpty)) {
      showToast('please enter a valid password');
    } else {
      if (prefs.getString(_email!) == null) {
        showToast("User does not exists please register first");
      } else {
        Map<String, dynamic> userMap =
            jsonDecode(SharedPrefs.instance.getString(email ?? '') ?? '');
        if (userMap['password'] != _password) {
          showToast("password is not matching");
        } else {
          prefs.setString(currentUser, _email!);
          showToast("User Login Successfully");
          return true;
        }
      }
    }
    return false;
  }
}
