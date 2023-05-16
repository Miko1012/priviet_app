import 'package:flutter/material.dart';

import '../page_parts/login_form.dart';
import '../page_parts/password_reset_form.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 20),
            child: const Text(
              "RESETOWANIE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 36,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 40),
            child: const Text(
              "HASŁA",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 36,
              ),
            ),
          ),
          const PasswordResetForm(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: InkWell(
              child: const Text(
                "Zresetowałeś hasło? Zaloguj się tutaj.",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ),
        ],
      ),
    );
  }
}
