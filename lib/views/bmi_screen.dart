import 'package:fitboost/view_models/bmi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/const.dart';
import 'food_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    BmiViewModel provider = context.read<BmiViewModel>();
    await provider.getAlreadyExistingValue();
  }

  @override
  Widget build(BuildContext context) {
    var availableWidth = (MediaQuery.of(context).size.width - 40) / 3;
    var provider = Provider.of<BmiViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              'BMI Value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
                fontSize: 32,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${provider.weight} kg',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${provider.height} cm',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.bmi.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 48,
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        children: [
                          const Text(
                            'BMI',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            provider.bmiStatus,
                            style: TextStyle(
                                fontSize: 18, color: provider.bmiStatusColor),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.grey.shade300,
                    indent: 12,
                    endIndent: 12,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Underweight',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        'Normal',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Overweight',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 24),
                        color: Colors.blue,
                        height: 2,
                        width: availableWidth,
                      ),
                      Container(
                        color: Colors.green,
                        height: 2,
                        width: availableWidth,
                      ),
                      Container(
                        // margin: EdgeInsets.only(right: 24),
                        color: Colors.red,
                        height: 2,
                        width: availableWidth,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '16.0',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        '18.5',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        '25.0',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        '40.0',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(networkImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              //Center widget and a container as a child, and a column widget
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Text widget for our app's title
                      const Text(
                        'Meal Planner',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      //space
                      const SizedBox(height: 20),
                      //A RichText to style the target calories
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    provider.targetCalories.toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: ' cal',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      //Orange slider that sets our target calories
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbColor: Colors.deepOrangeAccent,
                          activeTrackColor: Colors.deepOrangeAccent,
                          inactiveTrackColor: Colors.deepOrangeAccent[100],
                          trackHeight: 6,
                        ),
                        child: Slider(
                          min: 300,
                          max: provider.calories,
                          value: provider.targetCalories,
                          onChanged: (value) {
                            provider.targetCalories = value;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),
                      //FlatButton where onPressed() triggers a function called _searchMealPlan

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FoodScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          elevation: 2,
                          backgroundColor: Colors.deepOrangeAccent,
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
