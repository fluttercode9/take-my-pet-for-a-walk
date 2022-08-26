import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/media_helper.dart';

Future<File?> showChoiceDialog(BuildContext context) {
  // ValueChanged<File> onImageSelected;
  File? _img;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Wybierz opcję",
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () async {
                    _img = await MediaHelper.pickPhoto();
                    Navigator.of(context).pop(_img);
                  },
                  title: const Text("Galeria"),
                  leading: const Icon(
                    Icons.account_box,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () async {
                    _img = await MediaHelper.takePhoto();
                    Navigator.of(context).pop(_img);
                  },
                  title: const Text("Zrób zdjęcie"),
                  leading: const Icon(
                    Icons.camera,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
