import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key? key, required ScrollController this.scrollController})
      : super(key: key);
  final ScrollController scrollController;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var message;
  TextEditingController _controller = TextEditingController();

  void sendMessage() {
    DBhelper.firestore
        .collection('/chats/n8tqri1j48EpDmPQ5C0r/messages')
        .add({"text": message, "date": DateTime.now(), "userId" : DBhelper.auth.currentUser!.uid});
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
      decoration: BoxDecoration( color:Color.fromARGB(80, 27, 7, 116) ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: ((value) {
                setState(() {
                  message = value;
                });
              }),
              decoration: InputDecoration(
                label: Text('Abcd'),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                message == null ? null : sendMessage();
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
