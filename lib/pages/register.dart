import 'package:flutter/material.dart';
import 'package:priviet_app/page_parts/registration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: const Text(
              'REJESTRACJA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontSize: 36,
              ),
            ),
          ),
          const RegistrationForm(),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                child: const Text(
                  "Masz już konto? Zaloguj się tutaj.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => {Navigator.pushNamed(context, '/login')},
              )),
        ],
      ),
    );
  }
}
