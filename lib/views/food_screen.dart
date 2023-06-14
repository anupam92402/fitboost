import 'package:fitboost/views/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/bmi_view_model.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    BmiViewModel provider = context.read<BmiViewModel>();
    await provider.fetchUserMeal();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BmiViewModel>(context);
    return Scaffold(
      //has an appBar
      appBar: AppBar(
        title: const Text('Your Meal Plan'),
      ),
      //and body as a ListView builder
      body: ListView.builder(
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeScreen(id: provider.list[index].id),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              elevation: 12,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(provider.list[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          provider.list[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 2,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Protein:- ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              provider.list[index].protein,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 2,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'carbs:- ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              provider.list[index].carbs,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 2,
                              color: Colors.deepOrangeAccent,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Fats:- ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              provider.list[index].fat,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 2,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Calories:- ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              '${provider.list[index].calories.toString()}g',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12),
//                 margin: EdgeInsets.all(12),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: NetworkImage(widget.mealList[index].image),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Text(widget.mealList[index].title),
//               )
//             ],
//           );
