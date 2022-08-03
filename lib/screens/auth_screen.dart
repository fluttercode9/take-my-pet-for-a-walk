import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _nameState();
}

class _nameState extends State<AuthScreen> {
  @override
  void _switchMode() {
    setState(() {
      _loginMode = !_loginMode;
    });
  }

  void _trySubmit() {
    print('s');
    if (!_authFormKey.currentState!.validate()) {
      return;
    }
    print('ss');
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
                    _loginMode
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
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: _loginMode ? Text('Zaloguj') : Text('Zarejestruj'),
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
