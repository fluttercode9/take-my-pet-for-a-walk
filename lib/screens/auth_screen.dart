import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/helpers/media_helper.dart';
import 'package:okolicznie/providers/auth.dart';
import 'package:okolicznie/widgets/avatar.dart';
import 'package:okolicznie/widgets/imageChoiceDialog.dart';
import 'package:okolicznie/widgets/image_input.dart';
import 'package:provider/provider.dart';

import '../providers/currentUser.dart';
import '../widgets/file_avatar.dart';

class AuthScreen extends StatefulWidget {
  static final route = '/auth';
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loading = false;
  @override
  void _switchMode() {
    setState(() {
      _loginMode = !_loginMode;
    });
  }

  Future<void> _trySubmit() async {


    if (!_authFormKey.currentState!.validate()) {
      return;
    }
    _authFormKey.currentState!.save();

    await Auth.authenticateUser(
        email: _email!,
        password: _password!,
        context: context,
        loginMode: _loginMode,
        name: _name,
        phoneNumber: '123456789',
        profilePicture: _image);

  }

  String? _password;
  String? _email;
  String _name = "";
  File? _image;

  final _authFormKey = GlobalKey<FormState>();

  bool _loginMode = true;

  void onPhotoSelected() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 216, 210, 204),
      body: Container(
        decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/auth.jpg'), fit: BoxFit.fill)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Zwierzakowo",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget AuthForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 10,
      shadowColor: Colors.white,
      margin: EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _authFormKey,
            child: Column(
              children: [
                Text(
                  _loginMode ? "Logowanie" : "Rejestracja",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Fields(),
                ),
                loading
                    ? const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      )
                    : _ConfirmButton(),
                _switchModeButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Fields() => Column(
        children: [
          !_loginMode
              // only register fields
              ? _RegisterFields()
              : Container(),
          //end of only register fields
          TextFormField(
            onSaved: (newValue) => _email = newValue,
            validator: (value) {
              if (value == "") {
                return "Uzupelnij pole";
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('adres e-mail'),
              fillColor: Color.fromARGB(255, 229, 227, 225),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Divider(),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => _password = newValue,
            validator: (value) {
              if (value == "") {
                return "Uzupelnij pole";
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('hasło'),
              fillColor: Color.fromARGB(255, 229, 227, 225),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      );

  Widget _RegisterFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _profilePictureField(),
        Divider(),
        TextFormField(
          onSaved: (newValue) => _name = newValue!,
          validator: (value) {
            if (value == "") {
              return "Uzupelnij pole";
            }
            return null;
          },
          decoration: InputDecoration(
            label: Text('Imie'),
            fillColor: Color.fromARGB(255, 229, 227, 225),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _profilePictureField() {
    return GestureDetector(
      onTap: () async {
        File? _pickedImage;
        _pickedImage = await showChoiceDialog(context);
        if (_pickedImage == null) return;
        _image = _pickedImage;
        setState(() {});
      },
      child: _image == null
          ? const Avatar(radius: 100, url: 'https://i.pravatar.cc/300')
          : FileAvatar(radius: 100, image: _image!),
    );
  }

  Widget _ConfirmButton() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: CupertinoButton(
          color: Colors.brown,
          onPressed: ()  {
             _trySubmit();
          },
          child: _loginMode ? const Text('Zaloguj') : const Text('Zarejestruj'),
        ),
      );
  Widget _switchModeButton() {
    return _loginMode
        ? TextButton(onPressed: _switchMode, child: const Text("Nie mam konta"))
        : TextButton(onPressed: _switchMode, child: const Text('Mam konto'));
  }
}
