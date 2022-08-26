import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileAvatar extends StatelessWidget {
  const FileAvatar({Key? key, required this.radius, required this.image})
      : super(key: key);
  final double radius;
  final File image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(image),
    );
  }
}
