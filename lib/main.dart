import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/providers/auth.dart';
import 'package:okolicznie/providers/currentUser.dart';
import 'package:okolicznie/screens/auth_screen.dart';
import 'package:okolicznie/screens/chat_screen.dart';
import 'package:okolicznie/screens/home_screen.dart';
import 'package:okolicznie/screens/map_screen.dart';
import 'package:okolicznie/screens/pet_detail_screen.dart';
import 'package:okolicznie/screens/splash_screen.dart';
import 'package:okolicznie/screens/user_chats_screen.dart';
import '../screens/add_event_screen.dart';
import 'screens/board_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'helpers/navigation_helper.dart';
import 'providers/chats.dart';
import 'providers/events.dart';

void main() async {
  runApp(
    SplashScreen(
      onInitComplete: () {
        print('hi');
        runApp(
          MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Chats(),
          lazy: true,
        ),
        ChangeNotifierProvider<Events>(
          create: (_) => Events(),
        ),
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Zwierzakowe sprawy',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Color.fromARGB(203, 47, 115, 100),
          textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.lato(textStyle: textTheme.bodyText1),
            bodyText2: GoogleFonts.lato(textStyle: textTheme.bodyText2),
            button: GoogleFonts.lato(textStyle: textTheme.button),
          

          ),
          buttonTheme: ButtonThemeData()

        ),
        home: HomeScreen(),
        navigatorKey: NavigationHelper.navigatorKey,
        routes: {
          HomeScreen.route: (ctx) => HomeScreen(),
          AddEventScreen.route: (ctx) => AddEventScreen(),
          MapScreen.route: (context) => MapScreen(),
          PetDetailScreen.route: (context) => PetDetailScreen(),
          ChatScreen.route: (ctx) => ChatScreen(),
          EventsListScreen.route: (ctx) => EventsListScreen(),
          AuthScreen.route: (ctx) => AuthScreen(),
          UserChatsScreen.route: (ctx) => UserChatsScreen(),
        },
      ),
    );
  }
}
