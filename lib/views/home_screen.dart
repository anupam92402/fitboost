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
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);
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
                return const showBottomSheetToUser();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      drawer: const NavigationDrawerClass(),
      body: provider.getCurrentScreen(),
    );
  }
}
