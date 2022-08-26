import 'package:flutter/material.dart';
import 'package:okolicznie/models/app_user.dart';
import 'package:okolicznie/widgets/app_bar.dart';
import 'package:okolicznie/widgets/chat/messages.dart';
import 'package:okolicznie/widgets/chat/new_message.dart';


class ChatScreen extends StatefulWidget {
  static const route = '/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Map<String, AppUser> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, AppUser>;
    AppUser recepient = args['recepient']!;
    String recepientId = recepient.uid;

    return Scaffold(
      appBar: CustomAppBar(title: recepient.name),
      body: Column(
        children: [
          Messages(scrollController: _scrollController, recepient: recepient),
          NewMessage(
            scrollController: _scrollController,
            ownerId: recepientId,
          )
        ],
      ),
    );
  }
}
