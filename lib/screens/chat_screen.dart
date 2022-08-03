import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';

class ChatScreen extends StatefulWidget {
  static final route = '/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Stream<QuerySnapshot> _snapshots = DBhelper.firestore
      .collection('/chats/n8tqri1j48EpDmPQ5C0r/messages')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(onPressed: () {
          DBhelper.firestore
              .collection('/chats/n8tqri1j48EpDmPQ5C0r/messages')
              .add({'text': 'Co tam'});
        }),
        body: StreamBuilder(
            stream: _snapshots,
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    Container(child: Text(snapshot.data!.docs[index]['text'])),
              );
            })));
  }
}
