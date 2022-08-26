import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/providers/auth.dart';
import 'package:okolicznie/widgets/chat/message_bubble.dart';

import '../../models/app_user.dart';

class Messages extends StatefulWidget {
  Messages(
      {Key? key, required this.scrollController, required AppUser this.recepient})
      : super(key: key);
  final ScrollController scrollController;
  final AppUser recepient;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    String chatId = DBhelper.getChatRoomIdByUserId(
        FirebaseAuth.instance.currentUser!.uid, widget.recepient.uid);
    return Expanded(
      child: Container(
        color: Color.fromARGB(31, 255, 255, 255),
        child: StreamBuilder(
          stream: DBhelper.firestore
              .collection('/chats/$chatId/messages')
              .orderBy('date')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              DBhelper.markChatAsRead(chatId);
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var message = snapshot.data!.docs[index];
                  return MessageBubble(
                    
                    recepient: widget.recepient,
                      isSender:
                          FirebaseAuth.instance.currentUser!.uid == message['userId'],
                      text: message['text']);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
