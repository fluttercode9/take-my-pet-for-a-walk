import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaHelper {
  static Future<File?> takePhoto() async {
    final XFile? imageXfile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageXfile == null) {
      return null;
    }
    final File imageFile = File(imageXfile.path);
    return imageFile;
  }

  static Future<File?> pickPhoto() async {
    final XFile? imageXfile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageXfile == null) {
      return null;
    }
    final File imageFile = File(imageXfile.path);
    return imageFile;
  }

  
}
