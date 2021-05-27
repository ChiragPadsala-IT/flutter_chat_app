import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({this.message, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
              : BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: isSendByMe
                ? [Colors.purple,Colors.transparent,Colors.purpleAccent]
                : [Colors.blueGrey,Colors.transparent,Colors.blueGrey],
          ),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}