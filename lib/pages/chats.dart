import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final _chats = [];

  Future<void> handleClick(String choice) async {
    switch (choice) {
      case 'Wyloguj się':
        await storage.delete(key: 'access-token');
        await storage.delete(key: 'logged-as');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        break;
      case 'Moje konto':
        // #TODO: zrobić screena z informacjami o użytkowniku
        break;
    }
  }

  void createNewChat(String addressee) {

  }

  void showNewChatModal() {
    final _controller = TextEditingController();

    showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tworzenie nowego czatu'),
          contentPadding: const EdgeInsets.all(8.0),
          content: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nazwa użytkownika',
              ),
              controller: _controller,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => createNewChat(_controller.text),
              child: const Text('Utwórz'),
            ),
          ],
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Czaty'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Wyloguj się', 'Moje konto'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _chats.isEmpty
          ? const Center(
              child: Text(
                'Nie masz żadnych czatów. Utwórz nową konwersację za pomocą '
                'przycisku w prawym dolnym rogu ekranu.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : const Center(
              child: Text('tu będą czaty'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNewChatModal,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
