import 'package:flutter/material.dart';
import 'package:priviet_app/helpers/api_helper.dart';
import 'package:priviet_app/helpers/rsa_helper.dart';
import 'package:flutter/services.dart';

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key? key}) : super(key: key);

  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final _formKey = GlobalKey<FormState>();
  late String login;
  late String recoveryKey;
  late String newPassword;

  void resetPassword() async {
    APIHelper api = APIHelper();
    RSAHelper rsa = RSAHelper();
    int passwordResetStatus =
    await api.setNewPassword(login, recoveryKey, newPassword);
    switch (passwordResetStatus) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pomyślnie ustawiono nowe hasło użytkownika!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nie udało się ustawić nowego hasła!'),
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
                  labelText: 'Kod resetowania hasła',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wpisz swój kod resetowania hasła';
                  } else {
                    recoveryKey = value;
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nowe hasło',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wpisz swoje nowe hasło';
                  } else {
                    newPassword = value;
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
                      content: Text('Ustawiam nowe hasło...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  resetPassword();
                }
              },
              child: const Text('Ustaw nowe hasło'),
            ),
          ],
        ),
      ),
    );
  }
}
