import 'package:flutter/material.dart';
import 'package:okolicznie/screens/auth_screen.dart';
import 'package:okolicznie/screens/chat_screen.dart';
import 'package:okolicznie/screens/map_screen.dart';
import 'package:okolicznie/screens/pet_detail_screen.dart';
import '../screens/add_event_screen.dart';
import '../screens/events_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/events.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Events>(
          create: (_) => Events(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.indigo, primaryColor: Colors.indigo[700]),
        initialRoute: '/',
        routes: {
          '/': (context) => EventsListScreen(),
          AddEventScreen.route: (ctx) => AddEventScreen(),
          MapScreen.route: (context) => MapScreen(),
          PetDetailScreen.route: (context) => PetDetailScreen(),
          ChatScreen.route: (ctx) => ChatScreen(),
        },
      ),
    );
  }
}
