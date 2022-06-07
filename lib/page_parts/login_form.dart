import 'package:flutter/material.dart';
import 'package:priviet_app/helpers/api_helper.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String login;
  late String password;

  void logIn() async {
    APIHelper api = APIHelper();
    int loginStatus =
    await api.loginUser(login, password);
    switch (loginStatus) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pomyślnie zalogowano!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)));
        Navigator.of(context).pushNamedAndRemoveUntil('/chats' , (Route<dynamic> route) => false);
        break;
      case 401:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nieprawidłowe dane logowania!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wystąpił błąd podczas logowania!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Login',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Wpisz swoją nazwę użytkownika!';
                } else {
                  login = value;
                }
                return null;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Hasło',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Wpisz swoje hasło!';
                } else {
                  password = value;
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 130),
              primary: Colors.purple,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Loguję użytkownika...'), duration: Duration(seconds: 2),),
                );
                logIn();
              }
            },
            child: const Text('Zaloguj'),
          ),
        ],
      ),
    );
  }
}
