import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    Key? key,
    required ScrollController this.scrollController,
    required String this.ownerId,
  }) : super(key: key);
  final ScrollController scrollController;
  final String ownerId;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var message;
  String myId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _controller = TextEditingController();
  void sendMessage() {
    // String chatId = "${myId}+${widget.ownerId}";
    String chatId = DBhelper.getChatRoomIdByUserId(myId, widget.ownerId);
    // add new chat to user chats if doesnt exist
    DBhelper.firestore
        .collection('/users')
        .doc(myId)
        .collection('/chats')
        .doc(chatId)
        .set({'read': true});
    // add new chat to owner chats if doesnt exist
    DBhelper.firestore
        .collection('/users')
        .doc(widget.ownerId)
        .collection('/chats')
        .doc(chatId)
        .set({'read': false});
    // add message to chat
    DBhelper.firestore
        .collection('/chats/')
        .doc(chatId)
        .collection('/messages')
        .add({
      "text": message,
      "date": DateTime.now(),
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });
    DBhelper.firestore.collection('/chats/').doc(chatId).set({
      'users': [myId, widget.ownerId],
      'lastMessage': DateTime.now(),
    });

    setState(() {
      message = null;
      _controller.clear();
    });
    FocusManager.instance.primaryFocus?.unfocus();
    widget.scrollController.animateTo(20000,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 101, 150, 139)),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              maxLength: 1000,
              controller: _controller,
              onChanged: ((value) {
                setState(() {
                  message = value;
                });
              }),
              decoration: const InputDecoration(
                label: Text(
                  'Abcd',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                message == null ? null : sendMessage();
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
