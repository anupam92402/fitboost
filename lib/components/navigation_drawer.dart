import 'dart:developer';
import 'dart:io';
import 'package:fitboost/utils/const.dart';
import 'package:fitboost/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawerClass extends StatefulWidget {
  const NavigationDrawerClass({super.key});

  @override
  State<NavigationDrawerClass> createState() => _NavigationDrawerClassState();
}

class _NavigationDrawerClassState extends State<NavigationDrawerClass> {
  String userName = '', userEmail = '', imagePath = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          myDrawerHeader(),
          menuItem(
              context, DrawerSection.home, Icons.home, Colors.grey.shade900),
          menuItem(
              context, DrawerSection.edit, Icons.edit, Colors.grey.shade900),
          menuItem(context, DrawerSection.bmi, Icons.fastfood_rounded,
              Colors.grey.shade900),
          menuItem(context, DrawerSection.steps, Icons.directions_walk,
              Colors.grey.shade900),
          menuItem(context, DrawerSection.logout, Icons.logout, Colors.red),
        ],
      ),
    );
  }

  Widget myDrawerHeader() {
    String? email = SharedPrefs.instance.getString(currentUser);

    try {
      Map<String, dynamic> userMap = getUserMap();
      userEmail = email ?? '';
      userName = userMap['name'];
      imagePath = userMap['image'];
    } catch (exception) {
      log(exception.toString());
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

  ListTile menuItem(
      BuildContext context, DrawerSection title, IconData icon, Color color) {
    var provider = Provider.of<HomeViewModel>(context);
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title.name,
        style: TextStyle(color: color),
      ),
      onTap: () {
        provider.setCurrentDrawerItem(title, context);
      },
    );
  }
}
