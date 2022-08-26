import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/screens/chat_screen.dart';
import 'package:okolicznie/widgets/chat/message_tile.dart';
import 'package:provider/provider.dart';
import '../models/chat_tile.dart';
import '../providers/auth.dart';
import '../providers/chats.dart';

class UserChatsScreen extends StatefulWidget {
  static final route = '/user-chats';
  UserChatsScreen({Key? key}) : super(key: key);

  @override
  State<UserChatsScreen> createState() => _UserChatsScreenState();
}

class _UserChatsScreenState extends State<UserChatsScreen> {
  @override
  late Chats _chatsProvider;
  late Auth _auth;
  List<StreamSubscription> subs = [];

  bool init = false;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<Auth>(context);
    return _buildUi(context);
  }

  Scaffold _buildUi(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          _chatsProvider = Provider.of<Chats>(context);
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: _chatsProvider.chats!.length,
              addAutomaticKeepAlives: true,
              itemBuilder: (context, index) {
                ChatTile chatItem = _chatsProvider.chats![index].keys.first;
                return _chatTile(context, chatItem);
              },
            ),
          );
        },
      ),
    );
  }

  MessageTile _chatTile(BuildContext context, ChatTile chatItem) {
    return MessageTile(
      
        key: UniqueKey(),
        read: chatItem.read,
        chatId: chatItem.chatId,
        height: MediaQuery.of(context).size.height * 0.1,
        title: chatItem.title,
        imageUrl: chatItem.imageURL(),
        subtitle: chatItem.messages.first.text,
        isActive: chatItem.recepient.wasRecentlyActive(),
        onTap: () {
          Navigator.of(context).pushNamed(ChatScreen.route,
              arguments: {'recepient': chatItem.recepient});
        });
  }
}
