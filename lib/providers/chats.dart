import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:okolicznie/models/chat_tile.dart';

import '../helpers/db_helper.dart';
import '../models/app_user.dart';
import '../models/chat_message.dart';
import 'auth.dart';

class Chats with ChangeNotifier {
  // TO DO --- CHAT MODEL , FACRTORY
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _chatsStream;
  List<
          Map<ChatTile,
              StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>>
      _chats = [];

  //chats

  List<
          Map<ChatTile,
              StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>>?
      get chats {
    return [..._chats];
  }
// unread

  int _unread = 0;
  String? get unreadS => _unread.toString();
  Chats() {
    print("INICJALIZACJA");
    getChats();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getChatsForUser(String uid) {
    return DBhelper.firestore
        .collection('chats')
        .where('users', arrayContains: uid)
        .orderBy('lastMessage', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chats = [];
    _chatsStream.cancel();
    _chatsStream.cancel();
    super.dispose();
  }

  Future<QuerySnapshot> lastMessage(chatId) {
    return DBhelper.firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
  }

  bool _init = true;
  void getChats() async {
    try {
      _chatsStream =
          _getChatsForUser(FirebaseAuth.instance.currentUser!.uid).listen(
        (snap) async {
          print('hejs, ${snap.docs.length}');
          _chats = await Future.wait(
            snap.docs.map(
              (QueryDocumentSnapshot<Map<String, dynamic>> e) async {
                print(' huuuuuuuu $e');
                List<AppUser> members = [];
                List<ChatMessage> messages = [];
                Map<String, dynamic> chatData = e.data();
                List membersData = chatData['users'];
                for (var id in membersData) {
                  DocumentSnapshot userSnapshot = await DBhelper.getUser(id);
                  Map<String, dynamic> userData =
                      userSnapshot.data() as Map<String, dynamic>;
                  members.add(AppUser.fromFirestore(userData));
                }
                QuerySnapshot lastMessageSnap = await lastMessage(e.id);
                Map<String, dynamic> lastMessageData =
                    lastMessageSnap.docs.last.data() as Map<String, dynamic>;
                messages.add(ChatMessage.fromFirebase(lastMessageData));
                StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
                    userChatStream =
                    DBhelper.getUserChatStream(e.id).listen((chatSnap) async {
                  //
                  Map<String, dynamic> data =
                      chatSnap.data() as Map<String, dynamic>;
                  QuerySnapshot<Map<String, dynamic>> q =
                      await DBhelper.getAmounOfUnreadMessages();
                  _unread = q.docs.length;
                  notifyListeners();
                });

                //

                return {
                  ChatTile(
                    chatId: e.id,
                    members: members,
                    messages: messages,
                  ): userChatStream
                };
              },
            ),
          );
          print('co jest kurwa $_unread');
          notifyListeners();
          print(_chats);
        },
      );
    } catch (e) {
      print(e);
    }
    _init = false;
  }
}
