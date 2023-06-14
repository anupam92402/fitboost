import 'dart:io';

import 'package:fitboost/view_models/edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/const.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController? _nameController;
  TextEditingController? _weightController;
  TextEditingController? _heightController;
  TextEditingController? _ageController;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    EditViewModel provider = context.read<EditViewModel>();
    await provider.getAlreadyExistingValue();

    _nameController = TextEditingController(text: provider.name);
    _weightController = TextEditingController(text: provider.weight);
    _heightController = TextEditingController(text: provider.height);
    _ageController = TextEditingController(text: provider.age);

    _nameController?.addListener(() {
      provider.name = _nameController?.text ?? "null passed";
    });
    _weightController?.addListener(() {
      provider.weight = _weightController?.text ?? "null passed";
    });
    _heightController?.addListener(() {
      provider.height = _heightController?.text ?? "null passed";
    });
    _ageController?.addListener(() {
      provider.age = _ageController?.text ?? "null passed";
    });
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _weightController?.dispose();
    _heightController?.dispose();
    _ageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditViewModel>();
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await provider.getImageFromGallery();
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: (provider.image != '')
                  ? FileImage(File(provider.image))
                  : const AssetImage('assets/images/user_profile.png')
                      as ImageProvider,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: 'Enter Your Name', hintText: provider.name),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(
                labelText: 'Enter Your Weight', hintText: '${provider.weight}'),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
                labelText: 'Enter Your Height', hintText: '${provider.height}'),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
                labelText: 'Enter Your Age', hintText: '${provider.age}'),
          ),
          const SizedBox(
            height: 8,
          ),
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
            height: 24,
          ),
          TextButton(
            onPressed: () {
              provider.updateUserDetails(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
