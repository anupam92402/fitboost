import 'package:fitboost/views/home_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: [
          Pages(
            title: 'Caloric Intake Calculation',
            description:
                'Track how much calories you need to consume per day according to your height, weight and other parameters',
            btnText: 'Next',
            image: 'assets/images/fitness.png',
            pageController: controller,
            index: 0,
          ),
          Pages(
            title: 'Gets Food Suggestion',
            description:
                'You will get a list of food based on the calories you choose and the ingredients, recipe to make',
            btnText: 'Next',
            image: 'assets/images/fitness.png',
            pageController: controller,
            index: 1,
          ),
          Pages(
            title: 'Track Calories Burned',
            description:
                'See how many calories you have burned by 3 different modes walking, brisk walk and running etc',
            btnText: 'Get\'s Started',
            image: 'assets/images/fitness.png',
            pageController: controller,
            index: 2,
          ),
        ],
      ),
    );
  }
}

class Pages extends StatelessWidget {
  final String title, description, image, btnText;
  final PageController pageController;
  final int index;
  const Pages(
      {super.key,
      required this.title,
      required this.pageController,
      required this.description,
      required this.image,
      required this.btnText,
      required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(image),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 56,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  switch (index) {
                    case 0:
                    case 1:
                      pageController.jumpToPage(index + 1);
                      break;
                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(),
                        ),
                      );
                      break;
                  }
                },
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  btnText,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
