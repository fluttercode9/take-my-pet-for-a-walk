import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/screens/chat_screen.dart';
import 'package:okolicznie/screens/map_screen.dart';

import '../models/app_user.dart';
import '../models/event.dart';

class PetDetailScreen extends StatelessWidget {
  static final route = '/pet-detail';
  const PetDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Event;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: _Contact(pet: pet),
      appBar: AppBar(
        title: Text(
          pet.title,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  pet.imageUrl,
                ),
              ),
              Card(
                child: Text("${pet.title}", style: TextStyle(fontSize: 30)),
              ),
              Card(
                child: Text(
                  pet.description,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: size.height / 80,
              ),
              TextButton.icon(
                onPressed: () {
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({
    Key? key,
    required this.pet,
  }) : super(key: key);

  final Event pet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton.icon(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(100, 100.0))),
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
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                AppUser recepient;
                DocumentSnapshot snap = await DBhelper.getUser(pet.ownerId);
                Map<String, dynamic> userData =
                    snap.data() as Map<String, dynamic>;
                recepient = AppUser.fromFirestore(userData);
                Navigator.of(context).pushNamed(ChatScreen.route, arguments: {
                  'recepient': recepient,
                });
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
      ),
    );
  }
}
