import 'package:fitboost/models/calories_data.dart';
import 'package:fitboost/utils/const.dart';
import 'package:fitboost/view_models/calories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/update_calories_bottom_sheet.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await CalorieViewModel().getAlreadyExistingValues();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CalorieViewModel>(context);

    showAlertDialog(BuildContext context, int index) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () => Navigator.pop(context),
      );
      Widget deleteButton = TextButton(
        child: const Text("Delete"),
        onPressed: () {
          provider.deleteItemFromList(index);
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Delete"),
        content: Text("Are you sure to delete item ${provider.foodEaten} ?"),
        actions: [
          cancelButton,
          deleteButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    List<CaloriesData> list = provider.getCaloriesList();
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Text(
          "Hi ${provider.userName}",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => provider.selectDate(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.date),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: provider.getProgressBarValue(),
            color: (provider.caloriesTakenValue >
                    provider.totalCaloriesToBurnValue)
                ? Colors.red
                : Colors.blue,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          '${provider.caloriesTakenValue} / ${provider.totalCaloriesToBurnValue}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorList[index % colorList.length],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          list[index].foodName.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => provider
                            .setInitialValues(list[index])
                            .then((value) => showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UpdateCalorieBottomSheet(
                                        id: list[index].id);
                                  },
                                )),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () => showAlertDialog(context, index),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    '${list[index].foodCalories.toString()} cal',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    list[index].mealType,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            );
          },
          itemCount: list.length,
        )
      ],
    );
  }
}
