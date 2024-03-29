import 'package:flutter/material.dart';
import 'package:priviet_app/helpers/api_helper.dart';
import 'package:priviet_app/helpers/rsa_helper.dart';
import 'package:flutter/services.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String login;
  late String password;

  void register() async {
    APIHelper api = APIHelper();
    RSAHelper rsa = RSAHelper();
    String publicKey = await rsa.generateKeyPair(login);
    Map registrationStatus =
        await api.registerUser(name, login, password, publicKey);
    switch (registrationStatus['status']) {
      case 201:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pomyślnie zarejestrowano użytkownika!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)));
        _showRecoveryCode(registrationStatus['recovery_code']);
            // print(registrationStatus['recovery_code']);
        break;
      case 409:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Podany login jest zajęty!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wystąpił błąd przy rejestracji!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)));
        break;
    }
  }

  Future<void> _showRecoveryCode(String recoveryCode) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Odzyskiwanie hasła'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Twoje konto zostało pomyślnie utworzone.'),
                const Text('Zachowaj poniższy kod, aby móc zresetować hasło w przyszłości.'),
                Text(recoveryCode),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Skopiuj kod'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: recoveryCode));
              },
            ),
            TextButton(
              child: const Text('Zachowałem kod do resetowania hasła'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Imię i nazwisko',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wpisz swoje imię i nazwisko';
                  } else {
                    name = value;
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Login',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wpisz swój login';
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
                    return 'Wpisz hasło';
                  } else {
                    password = value;
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                primary: Colors.purple,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rejestruję użytkownika...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  register();
                }
              },
              child: const Text('Zarejestruj'),
            ),
          ],
        ),
      ),
    );
  }
}
