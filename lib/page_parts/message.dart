import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final String sender;
  final String addressee;
  final String message;
  final String datetime;
  final String user;
  const Message({
    required this.sender,
    required this.addressee,
    required this.message,
    required this.datetime,
    required this.user,
    Key? key
  }) : super(key: key);

  String getTime(String datetimeString) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final datetime = DateTime.parse(datetimeString);
    final dateTimeDay = DateTime(datetime.year, datetime.month, datetime.day);
    if(today == dateTimeDay) {
      return(DateFormat('hh:mm').format(datetime));
    } else {
      return(DateFormat('dd.MM hh:mm').format(datetime));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sender == user) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(getTime(datetime), style: const TextStyle(fontSize: 12, color: Colors.black54),),
              flex: 2,
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsetsDirectional.only(start: 4.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              flex: 8,
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 4.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              flex: 8,
            ),
            Flexible(
              child: Text(getTime(datetime), style: const TextStyle(fontSize: 12, color: Colors.black54),),
              flex: 2,
            ),
          ],
        ),
      );
    }
  }
}
