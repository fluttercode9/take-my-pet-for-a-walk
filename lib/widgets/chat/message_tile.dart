import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/widgets/avatar.dart';
import '../../helpers/db_helper.dart';
import '../../providers/auth.dart';

class MessageTile extends StatefulWidget {
  double height;
  String title;
  String? imageUrl;
  String subtitle;
  bool isActive;
  Function onTap;
  String chatId;
  bool read = true;

  MessageTile(
      {Key? key,
      required this.read,
      required this.height,
      required this.title,
      required this.imageUrl,
      required this.subtitle,
      required this.isActive,
      required this.onTap,
      required this.chatId})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  void initState() {
    streamsub = DBhelper.firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(widget.chatId)
        .snapshots()
        .listen((chatSnap) {
      Map<String, dynamic> data = chatSnap.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          if (data['read'] == null) {
            return;
          }
          read = data['read'];
        });
      }
    });
    super.initState();
  }

  late StreamSubscription streamsub;
  late bool read = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DBhelper.getStreamForChat(widget.chatId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _initialTile();
          }
          Map<String, dynamic> messageData =
              snapshot.data!.docs.last.data() as Map<String, dynamic>;
          return _streamTile(messageData);
        });
  }

  Widget _streamTile(Map<String, dynamic> messageData) {
    return ListTile(
      minVerticalPadding: widget.height * 0.2,
      contentPadding: const EdgeInsets.all(0),
      leading: AvatarWithActivity(
        radius: widget.height / 2,
        url: widget.imageUrl,
        isActive: widget.isActive,
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: read == false ? FontWeight.w900 : FontWeight.w100,
        ),
      ),
      onTap: () => widget.onTap(),
      subtitle: Text(
        messageData['text'],
        style: TextStyle(
          fontSize: 17,
          fontWeight: read == false ? FontWeight.w900 : FontWeight.w100,
        ),
      ),
    );
  }

  Widget _initialTile() {
    return ListTile(
        minVerticalPadding: widget.height * 0.2,
        contentPadding: const EdgeInsets.all(0),
        leading: AvatarWithActivity(
          radius: widget.height / 2,
          url: widget.imageUrl,
          isActive: widget.isActive,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                widget.read == false ? FontWeight.w900 : FontWeight.w100,
          ),
        ),
        onTap: () => widget.onTap(),
        subtitle: Text(
          widget.subtitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight:
                widget.read == false ? FontWeight.w900 : FontWeight.w100,
          ),
        ));
  }
}
