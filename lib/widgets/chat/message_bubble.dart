import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isSender,
    required this.text,
  }) : super(key: key);
  final bool isSender;
  final String text;
  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      text: text,
      textStyle: TextStyle(color: isSender? Colors.white : Colors.black),
      isSender: isSender,
      color: isSender ? Color.fromARGB(255, 87, 78, 218) : Color.fromARGB(255, 255, 255, 255),
      tail: true,
    );
  }
}
