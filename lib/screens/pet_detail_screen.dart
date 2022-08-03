import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:okolicznie/screens/chat_screen.dart';
import 'package:okolicznie/screens/map_screen.dart';

import '../models/event.dart';

class PetDetailScreen extends StatelessWidget {
  static final route = '/pet-detail';
  const PetDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.title),
        elevation: 15,
        bottomOpacity: 10,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.lightBlue),
                color: Colors.amber,
              ),

              height: 250,
              // width: double.infinity,
              child: Image.network(
                pet.imageUrl,
              ),
            ),
          ),
          const Divider(
              color: Colors.blue,
              height: 20,
              thickness: 4,
              indent: 35,
              endIndent: 35),
          Card(
            child: Text("${pet.title}", style: TextStyle(fontSize: 30)),
          ),
          Card(
            child: Text(
              pet.description,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton.icon(
            onPressed: () {
              print(pet.location.latitude + pet.location.longitude);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MapScreen(
                    initialLocation: pet.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
            icon: Icon(Icons.map_outlined),
            label: Text("Zobacz na mapie"),
          ),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton.icon(
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(Size(100, 100.0))),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 55,
                  ),
                  label: const Text(
                    'Zadzwoń',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ChatScreen.route);
                  },
                  icon: const Icon(
                    Icons.message_outlined,
                    size: 55,
                  ),
                  label: const Text(
                    'Czat',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
