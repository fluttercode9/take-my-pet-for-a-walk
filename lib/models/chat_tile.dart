import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/models/chat_message.dart';

import '../providers/auth.dart';
import 'app_user.dart';

class ChatTile {
  final String chatId;
  final List<AppUser> members;
  List<ChatMessage> messages;
  late final AppUser _recepient;
  bool read = true;
  ChatTile({
    required this.chatId,
    required this.members,
    required this.messages,
  }) {
    _recepient = members
        .firstWhere((element) => element.uid != FirebaseAuth.instance.currentUser!.uid);
    // setRead();
  }

  AppUser get recepient => _recepient;

  String get title => _recepient.name;

  String? imageURL() {
    return _recepient.profilePictureUrl;
  }

  // Future<void> setRead() async {
  //   read = await DBhelper.getCurrentUserChatReadStatus(chatId);
  // }
}
