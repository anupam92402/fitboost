import 'dart:convert';
import 'dart:developer';
import 'package:fitboost/views/login_screen.dart';
import 'package:fitboost/views/user_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/const.dart';

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

  Future<void> registerUser(BuildContext context) async {
    if (_email == null || (_email != null && _email!.isEmpty)) {
      log('email either null or empty');
    } else if (_password == null || (_password != null && _password!.isEmpty)) {
      log('password either null or empty');
    } else if (_name == null || (_name != null && _name!.isEmpty)) {
      log('name either null or empty');
    } else {
      log('$_email');
      if (prefs.getString(_email!) != null) {
        log("User account already exists");
      } else if (emailRegex.hasMatch(_email ?? '') == false) {
        log("email not matching regex");
      } else if (passwordRegex.hasMatch(_password ?? '') == false) {
        log("password not matching regex");
      } else {
        User newUser =
            User.register(email: _email!, name: _name!, password: _password!);
        prefs.setString(_email!, jsonEncode(newUser));
        prefs.setString(currentUser, _email!);
        log(jsonEncode(newUser));
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserInfoScreen()),
        );
        log('user registered successfully');
        Fluttertoast.showToast(
            msg: "User Registered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<void Function()?> navigateToLoginScreen(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
