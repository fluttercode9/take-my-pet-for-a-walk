import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:okolicznie/widgets/avatar.dart';

import '../../models/app_user.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.isSender,
    required this.text,
    required this.recepient,
  }) : super(key: key);
  final bool isSender;
  final String text;
  final AppUser recepient;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          !isSender
              ? Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Avatar(radius: 25, url: recepient.profilePictureUrl))
              : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: BubbleSpecialOne(
                text: text,
                textStyle:
                    TextStyle(color: isSender ? Colors.white : Colors.black),
                isSender: isSender,
                color: isSender
                    ? Color.fromARGB(255, 47, 115, 100)
                    : Color.fromARGB(255, 210, 206, 197),
                tail: true,
                
                // delivered: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
