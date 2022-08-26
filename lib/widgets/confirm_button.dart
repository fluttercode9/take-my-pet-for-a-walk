import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final String title;
  final double fontSize;
  ConfirmButton(
      {Key? key,
      this.width = 100,
      this.height = 50,
      this.onPressed,
      required this.title,
      this.fontSize = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 15, 63, 83),
            fixedSize: Size(width, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: onPressed ?? () {},
          child: Text(
            title,
            style: TextStyle(fontSize: fontSize),
          )),
    );
  }
}
