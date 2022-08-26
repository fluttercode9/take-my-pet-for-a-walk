import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.title,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [],
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  final Size preferredSize;
  // Size get preferredSize => throw UnimplementedError();
}
