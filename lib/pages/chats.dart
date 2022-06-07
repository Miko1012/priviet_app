import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:priviet_app/data_classes/chat_data.dart';
import 'package:priviet_app/page_parts/chat.dart';

import '../helpers/api_helper.dart';
import '../helpers/rsa_helper.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final _chats = [];
  APIHelper api = APIHelper();
  RSAHelper rsa = RSAHelper();

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
      case 'Odśwież czaty':
        setState(() {
          _chats.clear();
        });
        print('getting chats!');
        List chatsJson = await api.getChats();
        List<ChatData> chatsData = chatsJson.map((chat) => ChatData.fromJson(chat)).toList();

        for (var c in chatsData) {
          var message = c.getMessage();
          print('message: '+message);
          String decrypted = await rsa.decryptMessage(message);
          // print('decrypted: '+decrypted);

          var chat = ChatListPosition(username: c.getUsername(),
              message: decrypted,
              datetime: c.getDatetime());
          setState(() {
            _chats.insert(0, chat);
          });
        }
        break;
    }
  }

  void createNewChat(String addressee) async{
    APIHelper api = APIHelper();
    int chatCreationStatus = await api.createNewChat(addressee);
    switch (chatCreationStatus) {
      case 200:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pomyślnie utworzono nowy czat!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3)));
        break;
      case 401:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Niedozwolona operacja!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
        break;
      case 404:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Podany adresat nie istnieje!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
        break;
      case 409:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Czat z tym użytkownikiem już istnieje!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wystąpił błąd podczas tworzenia nowego czatu!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
        break;
    }
    Navigator.pop(context);
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
              return {'Wyloguj się', 'Moje konto', 'Odśwież czaty'}.map((String choice) {
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
          : Column(
        children: [
      Flexible(
      child: ListView.builder(
      itemBuilder: (_, index) => _chats[index],
      itemCount: _chats.length,
    ), ),
        ],
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
