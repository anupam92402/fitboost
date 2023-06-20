import 'package:fitboost/view_models/login_view_model.dart';
import 'package:fitboost/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LoginViewModel>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 24, top: 100, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Enter Your Email', hintText: 'abc@gmail.com'),
              onChanged: (emailValue) {
                provider.email = emailValue;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Enter Password', hintText: 'Enter Your Password'),
              onChanged: (passwordValue) {
                provider.password = passwordValue;
              },
            ),
            const SizedBox(
              height: 56,
            ),
            TextButton(
              onPressed: () {
                if (provider.loginUser(context)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
