import 'dart:convert';
import 'dart:io';

import 'package:fitboost/utils/const.dart';
import 'package:fitboost/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerClass extends StatefulWidget {
  @override
  State<NavigationDrawerClass> createState() => _NavigationDrawerClassState();
}

class _NavigationDrawerClassState extends State<NavigationDrawerClass> {
  SharedPreferences prefs = SharedPrefs.instance;
  String userName = '', userEmail = '', imagePath = '';

  @override
  void initState() {
    super.initState();
  }

  void getFile() async {}

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          myDrawerHeader(),
          menuItem(context, DrawerSection.home, Icons.home),
          menuItem(context, DrawerSection.edit, Icons.edit),
          // menuItem(context, DrawerSection.graph, Icons.bar_chart),
          menuItem(context, DrawerSection.bmi, Icons.fastfood_rounded),
          menuItem(context, DrawerSection.steps, Icons.directions_walk),
          menuItem(context, DrawerSection.logout, Icons.logout),
        ],
      ),
    );
  }

  Widget myDrawerHeader() {
    String? email = prefs.getString(currentUser);
    if (email != null) {
      String? user = prefs.getString(email);
      if (user != null) {
        Map<String, dynamic> userMap = jsonDecode(user);
        // print('$userMap');
        userEmail = email;
        userName = userMap['name'];
        imagePath = userMap['image'];
        // if (userMap['image'] != null) {
        //   _getLocalFile(userMap['image']).then((value) => {
        //         setState(() {
        //           imagePath = value.path;
        //         }),
        //       });
        //   // imagePath = response.path;
        // }
      }
    }
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imagePath != ''
                ? FileImage(File(imagePath))
                : const AssetImage('assets/images/user_profile.png')
                    as ImageProvider,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            userName,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            userEmail,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
    );
  }

  ListTile menuItem(BuildContext context, DrawerSection title, IconData icon) {
    var provider = Provider.of<HomeViewModel>(context);
    return ListTile(
      leading: Icon(icon),
      title: Text(title.name),
      onTap: () {
        provider.setCurrentDrawerItem(title, context);
      },
    );
  }
}
