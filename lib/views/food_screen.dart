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

      body: provider.isDataLoaded == false
          ? ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 12,
                  shadowColor: Colors.grey,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Shimmer(
                          height: 170,
                          width: 100,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer(
                                height: 24,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Shimmer(
                                height: 12,
                                width: 109,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Shimmer(
                                height: 12,
                                width: 109,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Shimmer(
                                height: 12,
                                width: 109,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Shimmer(
                                height: 12,
                                width: 109,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeScreen(id: provider.list[index].id),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 12,
                    shadowColor: Colors.grey,
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 170,
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: 'assets/images/placeholder.png',
                                image: provider.list[index].image),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.list[index].title,
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                FoodCardDetails(
                                  index: index,
                                  text: "Proteins:- ",
                                  color: Colors.red,
                                  value: provider.list[index].protein,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FoodCardDetails(
                                    index: index,
                                    text: "Carbs:- ",
                                    color: Colors.blue,
                                    value: provider.list[index].carbs),
                                const SizedBox(
                                  height: 8,
                                ),
                                FoodCardDetails(
                                  index: index,
                                  text: "Fats:- ",
                                  color: Colors.deepOrangeAccent,
                                  value: provider.list[index].fat,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FoodCardDetails(
                                  index: index,
                                  text: "Calories:- ",
                                  color: Colors.green,
                                  value: '${provider.list[index].calories}g',
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    required this.height,
    required this.width,
  });

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
      ),
    );
  }
}

class FoodCardDetails extends StatelessWidget {
  const FoodCardDetails(
      {super.key,
      required this.index,
      required this.text,
      required this.color,
      required this.value});

  final int index;
  final String text, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 2,
          color: color,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
