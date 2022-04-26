import 'package:flutter/material.dart';

import '../page_parts/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: const Text(
              "LOGOWANIE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 36,
              ),
            ),
          ),
          const LoginForm(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              child: const Text(
                "Nie masz konta? Zarejestruj się tutaj.",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
          ),
        ],
      ),
    );
  }
}
