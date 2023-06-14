import 'package:fitboost/utils/const.dart';
import 'package:fitboost/view_models/calories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class showBottomSheetToUser extends StatefulWidget {
  const showBottomSheetToUser({Key? key}) : super(key: key);

  @override
  State<showBottomSheetToUser> createState() => _showBottomSheetToUserState();
}

class _showBottomSheetToUserState extends State<showBottomSheetToUser> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CalorieViewModel>(context, listen: true);
    return Container(
      color: const Color(0xff757575),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Add Calories Taken',
                style: TextStyle(color: Colors.black, fontSize: 32),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: const InputDecoration(
                          labelText: 'Enter Food Eaten', hintText: 'Apple'),
                      onChanged: (foodName) {
                        provider.foodEaten = foodName;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () => provider.fetchCalories(),
                    child: const Text(
                      'Get Calories',
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Icon(
                    provider.calorieStatusIcon,
                    color: provider.calorieStatusIconColor,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Food Calories",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  provider.foodCalories,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Meal Type",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Consumer<CalorieViewModel>(
                builder: (_, provider, __) {
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: provider.mealDropDown,
                    hint: const Text('Select meal type'),
                    onChanged: (newValue) {
                      provider.mealDropDown = newValue!;
                    },
                    items: mealTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              TextButton(
                onPressed: () {
                  var closeBottomSheet = provider.addUserCalories();
                  closeBottomSheet.then((value) {
                    if (value) {
                      Navigator.pop(context);
                    }
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Add Calories"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
