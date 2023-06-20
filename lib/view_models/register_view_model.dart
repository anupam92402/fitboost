import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/const.dart';

// registers a new user and navigate to the user info and onboarding screen if successful
class RegisterViewModel extends ChangeNotifier {
  SharedPreferences prefs = SharedPrefs.instance;

  String? _email, _password, _name;

  String? get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  String? get name => _name;

  set name(name) {
    _name = name;
    notifyListeners();
  }

  String? get password => _password;

  set password(password) {
    _password = password;
    notifyListeners();
  }

  // function to register who created the account for the very first time
  bool registerUser(BuildContext context) {
    if (_email == null || (_email != null && _email!.isEmpty)) {
      showToast('Please enter a valid email');
    } else if (_password == null || (_password != null && _password!.isEmpty)) {
      showToast('Please enter a valid password');
    } else if (_name == null || (_name != null && _name!.isEmpty)) {
      showToast('Please enter a valid name');
    } else {
      if (prefs.getString(_email!) != null) {
        showToast("User account already exists");
      } else if (emailRegex.hasMatch(_email ?? '') == false) {
        showToast("email not matching regex");
      } else if (passwordRegex.hasMatch(_password ?? '') == false) {
        showToast("password not matching regex");
      } else {
        User newUser =
            User.register(email: _email!, name: _name!, password: _password!);
        prefs.setString(_email!, jsonEncode(newUser));
        prefs.setString(currentUser, _email!);
        log('${RegisterViewModel().runtimeType.toString()} ${jsonEncode(newUser)}');
        showToast('user registered successfully');
        return true;
      }
    }
    return false;
  }
}
