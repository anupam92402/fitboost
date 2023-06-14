import 'dart:convert';
import 'dart:developer';
import 'package:fitboost/utils/const.dart';
import 'package:fitboost/views/home_screen.dart';
import 'package:fitboost/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> loginUser(BuildContext context) async {
    if (_email == null || (_email != null && _email!.isEmpty)) {
      log('email either null or empty');
    } else if (_password == null || (_password != null && _password!.isEmpty)) {
      log('password either null or empty');
    } else if (_email != null && _password != null) {
      if (prefs.getString(_email!) == null) {
        log("user does not exists please register first");
      } else {
        Map<String, dynamic> userMap = jsonDecode(prefs.getString(_email!)!);
        if (userMap['password'] != _password) {
          log("password is not matching");
        } else {
          prefs.setString(currentUser, _email!);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
          log('user login successfully');
          Fluttertoast.showToast(
              msg: "User Login Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  Future<void Function()?> navigateToRegisterScreen(
      BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
