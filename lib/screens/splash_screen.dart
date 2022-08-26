import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../firebase_options.dart';
import '../helpers/media_helper.dart';
import '../helpers/navigation_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.onInitComplete})
      : super(key: key);
  final VoidCallback onInitComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () {},
    ).then(
      (_) => _setup().then(
        (_) => widget.onInitComplete(),
      ),
    );
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<MediaHelper>(MediaHelper());
    GetIt.instance.registerSingleton<NavigationHelper>(NavigationHelper());
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _registerServices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ładowanie..."),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/logoo.png'))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
