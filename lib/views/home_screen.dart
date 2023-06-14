import 'package:fitboost/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/add_calories_bottom_sheet.dart';
import '../components/navigation_drawer.dart';
import '../utils/const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs = SharedPrefs.instance;
  @override
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fit Boost"),
      ),
      floatingActionButton: Visibility(
        visible: provider.visibility,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return showBottomSheetToUser();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      drawer: NavigationDrawerClass(),
      body: provider.getCurrentScreen(),
    );
  }

  // Widget currentPage(BuildContext context) {
  //   var currentDrawerItem =
  //       Provider.of<HomeViewModel>(context).getCurrentDrawerItem();
  //   if (currentDrawerItem == DrawerSection.calories) {
  //     return CaloriesScreen();
  //   } else if (currentDrawerItem == DrawerSection.gym) {
  //     return GymScreen();
  //   } else if (currentDrawerItem == DrawerSection.settings) {
  //     return SettingScreen();
  //   } else if (currentDrawerItem == DrawerSection.logout) {
  //     prefs.setString(currentUser, '');
  //     print('user logout ${prefs.getString(currentUser)}');
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => MyApp()),
  //         (Route<dynamic> route) => false);
  //     // Navigator.pop(context);
  //     // return LoginScreen();
  //   }
  //   return CaloriesScreen();
  // }
}
