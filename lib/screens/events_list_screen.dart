import 'package:flutter/material.dart';
import 'package:okolicznie/screens/add_event_screen.dart';
import 'package:okolicznie/screens/auth_screen.dart';
import 'package:okolicznie/screens/pet_detail_screen.dart';
import 'package:provider/provider.dart';

import '../helpers/db_helper.dart';
import '../models/event.dart';
import '../providers/events.dart';

class EventsListScreen extends StatefulWidget {
  static const route = '/events-list';
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  var isInit = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Events>(context).fetchEventsFromFirebase();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("okolicznie"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddEventScreen.route);
              },
              icon: Icon(Icons.add)),
          IconButton(onPressed: DBhelper.logout, icon: Icon(Icons.logout))
        ],
      ),
      body: Consumer<Events>(
          child: const Text("nie ma tu nic jeszcze :< ale możesz coś dodać!"),
          builder: (ctx, events, child) {
            return events.events.isEmpty
                ? child!
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: events.events.length,
                    itemBuilder: (context, index) {
                      Event event = events.events[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, PetDetailScreen.route,
                              arguments: event);
                        },
                        minVerticalPadding: 40,
                        visualDensity:
                            VisualDensity(vertical: 4, horizontal: 4),
                        leading: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(event.imageUrl)),
                        title: Text(event.title),
                      );
                    },
                  );
          }),
    );
  }
}
