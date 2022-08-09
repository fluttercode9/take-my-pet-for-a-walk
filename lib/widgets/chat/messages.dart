import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {
  Messages({Key? key, required this.scrollController}) : super(key: key);
  final ScrollController scrollController;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black12,
        child: StreamBuilder(
          stream: DBhelper.firestore
              .collection('/chats/n8tqri1j48EpDmPQ5C0r/messages')
              .orderBy('date')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var message = snapshot.data!.docs[index];
                  return MessageBubble(
                      isSender:
                          DBhelper.auth.currentUser!.uid == message['userId'],
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
