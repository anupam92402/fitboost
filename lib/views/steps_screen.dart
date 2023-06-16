import 'dart:developer';

import 'package:fitboost/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  int getSteps = 0;
  double caloriesBurnedWalk = 0;
  double caloriesBurnedBrisk = 0;
  double caloriesBurnedRun = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  HealthFactory health = HealthFactory();

  Future fetchData() async {
    int? steps;

    var types = [HealthDataType.STEPS];

    final now = DateTime.now();
    final midNight = DateTime(now.year, now.month, now.day);

    var permissions = [HealthDataAccess.READ];

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midNight, now);
      } catch (error) {
        log(error.toString());
      }
      log('steps:- $steps');

      setState(() {
        getSteps = steps ?? 0;
        caloriesBurnedWalk = getMetValue(
            height: 182,
            weight: 80,
            steps: getSteps,
            mode: ActivityMode.walking);
        caloriesBurnedBrisk = getMetValue(
            height: 182, weight: 80, steps: getSteps, mode: ActivityMode.brisk);
        caloriesBurnedRun = getMetValue(
            height: 182,
            weight: 80,
            steps: getSteps,
            mode: ActivityMode.running);
      });
    } else {
      log('authorization error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            fetchData();
          });
        },
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      'Steps:- $getSteps',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      healthCard(
                          title: 'Walk',
                          data: caloriesBurnedWalk.toStringAsFixed(2),
                          color: Colors.purple,
                          image: 'assets/images/health.png'),
                      healthCard(
                          title: 'Brisk Walk',
                          data: caloriesBurnedBrisk.toStringAsFixed(2),
                          color: Colors.green,
                          image: 'assets/images/step.png'),
                    ],
                  ),
                  healthCard(
                      title: 'Run',
                      data: caloriesBurnedRun.toStringAsFixed(2),
                      color: Colors.blue,
                      image: 'assets/images/calories.png'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget healthCard(
      {String title = "",
      String data = "",
      Color color = Colors.blue,
      required String image}) {
    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          Image.asset(image, width: 70),
          Text('$data kcal',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
