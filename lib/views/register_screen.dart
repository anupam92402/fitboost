import 'package:fitboost/view_models/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<RegisterViewModel>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 24, top: 100, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Register',
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
              decoration: const InputDecoration(
                  labelText: 'Enter Your Name', hintText: 'John Doe'),
              onChanged: (nameValue) {
                provider.name = nameValue;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Enter Your Password',
                  hintText: 'Enter Your Password'),
              onChanged: (passwordValue) {
                provider.password = passwordValue;
              },
            ),
            const SizedBox(
              height: 56,
            ),
            TextButton(
              onPressed: () async {
                await provider.registerUser(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Register"),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                await provider.navigateToLoginScreen(context);
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
