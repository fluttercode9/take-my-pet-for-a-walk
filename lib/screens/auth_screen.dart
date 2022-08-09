import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okolicznie/helpers/db_helper.dart';

import '../helpers/auth.dart';

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

  void _trySubmit() async {
    print('s');

    if (!_authFormKey.currentState!.validate()) {
      return;
    }
    _authFormKey.currentState!.save();
    setState(() {
      print('setstate');
      loading = true;
    });
    DBhelper.authenticateUser(
        email: _email!,
        password: _password!,
        context: context,
        loginMode: _loginMode,
        name: _name);
    setState(() {
      loading = false;
    });
  }

  String? _password;
  String? _email;
  String? _name;

  final _authFormKey = GlobalKey<FormState>();

  bool _loginMode = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _authFormKey,
                child: Column(
                  children: [
                    !_loginMode
                        ? TextFormField(
                            onSaved: (newValue) => _name = newValue,
                            validator: (value) {
                              if (value == "") {
                                return "Uzupelnij pole";
                              }
                              return null;
                            },
                            decoration: InputDecoration(label: Text('Imie')),
                          )
                        : Container(),
                    TextFormField(
                      onSaved: (newValue) => _email = newValue,
                      validator: (value) {
                        if (value == "") {
                          return "Uzupelnij pole";
                        }
                        return null;
                      },
                      decoration: InputDecoration(label: Text('adres e-mail')),
                    ),
                    TextFormField(
                      onSaved: (newValue) => _password = newValue,
                      validator: (value) {
                        if (value == "") {
                          return "Uzupelnij pole";
                        }
                        return null;
                      },
                      decoration: InputDecoration(label: Text('haslo')),
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _trySubmit,
                            child: _loginMode
                                ? Text('Zaloguj')
                                : Text('Zarejestruj'),
                          ),
                    _loginMode
                        ? TextButton(
                            onPressed: _switchMode,
                            child: Text("Nie mam konta"))
                        : TextButton(
                            onPressed: _switchMode, child: Text('Mam konto'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
