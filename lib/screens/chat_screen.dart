import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/widgets/chat/messages.dart';
import 'package:okolicznie/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static final route = '/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = new ScrollController();

  final Stream<QuerySnapshot> _snapshots = DBhelper.firestore
      .collection('/chats/n8tqri1j48EpDmPQ5C0r/messages')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    Map args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String ownerId = args['ownerId'];

    return FutureBuilder(
        future: DBhelper.userName(ownerId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            String name = snapshot.data as String;
            return Scaffold(
              appBar: AppBar(
                title: Text(name),
              ),
              body: Column(
                children: [
                  Messages(scrollController: _scrollController),
                  NewMessage(scrollController: _scrollController)
                ],
              ),
            );
          }
        });
  }
}
