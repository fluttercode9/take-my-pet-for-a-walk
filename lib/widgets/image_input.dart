import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okolicznie/screens/add_event_screen.dart';

class ImageInput extends StatefulWidget {
  final Function changeState;
  final Function editImage;
  ImageInput({Key? key, required this.changeState, required this.editImage})
      : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;
  dynamic _pickImageError;
  final ImagePicker picker = ImagePicker();

  Future<void> _chooseImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (image == null) {
      return;
    }
    final temp = File(image.path);

    _image = temp;
    widget.editImage(_image);

    setState(() {});
  }

  Future<void> _takeImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 600);
    if (image == null) {
      return;
    }
    final temp = File(image.path);
    _image = temp;
    widget.editImage(_image);
    widget.changeState(StepState.complete, FormSteps.image);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          children: [
            Container(
              width: width * 0.4,
              height: height * 0.15,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.indigoAccent, width: 1),
                  bottom: BorderSide(color: Colors.indigo, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: _image != null
                      ? Image.file(_image!)
                      : const Icon(Icons.photo_library_outlined),
                ),
              ),
            ),
            Expanded(
              child: Column(children: [
                Container(
                  width: width * 0.28,
                  height: height * 0.067,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.deepPurple[50]),
                    onPressed: () {
                      _takeImage();
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Zrób',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: width * 0.28,
                  height: height * 0.067,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.deepPurple[50]),
                    onPressed: () {
                      _chooseImage();
                    },
                    icon: Icon(Icons.image),
                    label: Text(
                      'Wybierz',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 14),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
