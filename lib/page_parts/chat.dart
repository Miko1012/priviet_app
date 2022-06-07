import 'package:flutter/material.dart';

import '../helpers/rsa_helper.dart';

class ChatListPosition extends StatelessWidget {
  const ChatListPosition({
    required this.username,
    required this.message,
    required this.datetime,
    Key? key,
  }) : super(key: key);
  final String username;
  final String message;
  final String datetime;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text(
                  username[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: Theme.of(context).textTheme.headline5),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(message, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => {},
    );
  }
}