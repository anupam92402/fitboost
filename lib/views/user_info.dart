import 'package:fitboost/view_models/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/const.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserInfoViewModel>(context);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 32, right: 32, top: 108),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await provider.getImageFromGallery();
              },
              child: CircleAvatar(
                radius: 65,
                backgroundImage: (provider.imageFile != null)
                    ? FileImage(provider.imageFile!)
                    : const AssetImage('assets/images/user_profile.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(
              height: 52,
            ),
            // GestureDetector(
            //     onTap: () => showIntegerDialog(),
            //     child: const Text("Enter your weight")),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Enter Your Current Weight', hintText: '50 kg'),
              onChanged: (newWeight) {
                provider.weight = newWeight;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Enter Your Current Height', hintText: '150 cm'),
              onChanged: (newHeight) {
                provider.height = newHeight;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Enter Your Current Age', hintText: '20 yrs'),
              onChanged: (newAge) {
                provider.age = newAge;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            // TextField(
            //   decoration: const InputDecoration(
            //       labelText: 'Enter Your Gender', hintText: 'Male'),
            //   onChanged: (newGender) {
            //     provider.gender = newGender;
            //   },
            // ),
            DropdownButton<String>(
              isExpanded: true,
              value: provider.gender,
              hint: const Text('Select your gender'),
              onChanged: (newValue) {
                provider.gender = newValue!;
              },
              items: genderList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 56,
            ),
            TextButton(
              onPressed: () {
                provider.submitUserInfo(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Submit Info"),
            ),
          ],
        ),
      ),
    );
  }
}
