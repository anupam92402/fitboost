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
            title: 'Title 1',
            description: 'lorem111111',
            btnText: 'Next',
            image: 'assets/images/fitness.png',
            pageController: controller,
            index: 0,
          ),
          Pages(
            title: 'Title 2',
            description: 'lorem222222',
            btnText: 'Next',
            image: 'assets/images/fitness.png',
            pageController: controller,
            index: 1,
          ),
          Pages(
            title: 'Title 3',
            description: 'lorem3333333',
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
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
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
        ),
      ],
    );
  }
}
