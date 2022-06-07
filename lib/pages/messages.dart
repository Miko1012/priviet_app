import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:priviet_app/data_classes/message_data.dart';

import '../helpers/api_helper.dart';
import '../helpers/rsa_helper.dart';
import '../page_parts/message.dart';
import '../page_parts/message_composer.dart';


class MessagesScreen extends StatefulWidget {
  final String username;

  const MessagesScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final _messages = [];
  APIHelper api = APIHelper();
  RSAHelper rsa = RSAHelper();

  void getMessages() async {
    setState(() {
      _messages.clear();
    });
    var user = await storage.read(key: 'logged-as');

    List messagesJson = await api.getMessages(widget.username);
    List<MessageData> messagesData = messagesJson.map((message) => MessageData.fromJson(message)).toList();

    for (var m in messagesData) {
      print('message: ' + m.getMessage());
      var messageDecoded = await rsa.decryptMessage(m.getMessage());
      var message = Message(sender: m.getSender(), addressee: m.getAddressee(), message: messageDecoded, datetime: m.getDatetime(), user: user as String);
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text("Wiadomości z " + widget.username)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _messages.isEmpty
              ? const Text('Nie ma żadnych wiadomości')
              : Flexible(
            child: ListView.builder(
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MessageComposer(addressee: widget.username),
          )
        ],
      ),
    );
  }
}
