import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/screens/add_event_screen.dart';
import 'package:okolicznie/screens/pet_detail_screen.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/events.dart';

class EventsListScreen extends StatefulWidget {
  static const route = '/events-list';
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  double radius = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<Events>(context, listen: false).fetchEventsFromFirebase(radius);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 45.0, right: 0),
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: SizedBox(
              width: MediaQuery.of(context).size.width*0.36,
              height:MediaQuery.of(context).size.height*0.045 ,
              child: ElevatedButton(
                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(153, 47, 115, 100)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side:
                          const BorderSide(color: Color.fromARGB(255, 5, 0, 0)),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AddEventScreen.route);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AddEventScreen.route);
                      },
                      // color: Color.fromARGB(203, 47, 115, 100),
                      child: const Text(
                        'Dodaj sprawę',
                        style: TextStyle(
                            color: Color.fromARGB(202, 255, 255, 255),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios, size:15,
                      color: Color.fromARGB(202, 255, 255, 255),
                    ),
                  ],
                ),
              )),
        ),
      ),
      body: Consumer<Events>(
          child: const Text("nie ma tu nic jeszcze :< ale możesz coś dodać!"),
          builder: (ctx, events, _) {
            return Column(
              children: [
                DistanceSlider(
                  radius: radius,
                  onSet: (value) {
                    if (mounted) {
                      radius = value;
                      print(radius);
                      events.fetchEventsFromFirebase(radius);
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: events.events.length,
                    itemBuilder: (context, index) {
                      Event event = events.events[index];
                      return ListItem(
                        event: event,
                        key: UniqueKey(),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: size.width,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, PetDetailScreen.route,
                arguments: event);
          },
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    height: size.height * 0.18,
                    width: size.width * 0.4,
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                    ))),
            SizedBox(
              width: size.width / 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 19, color: Color.fromARGB(255, 87, 90, 90),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 5),
                  child: Text(
                    event.description.length > 70
                        ? '${event.description.substring(0, 70)}...'
                        : event.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            )),
          ]),
        ),
      ),
    );
  }
}

class DistanceSlider extends StatefulWidget {
  const DistanceSlider({Key? key, required this.radius, required this.onSet})
      : super(key: key);
  final double radius;
  final Function onSet;

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  @override
  void initState() {
    value = widget.radius;
    // TODO: implement initState
    super.initState();
  }

  late double value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0, right: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Color.fromARGB(153, 207, 224, 220),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'promień ${value.toInt().toString()} kilometrów',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,),
                    child: _DistanceButton(widget: widget, value: value),
                  )
                ],
              ),
              SizedBox(
                width: 350,
                child: CupertinoSlider(
                  thumbColor: Colors.black,
                  activeColor: Colors.black,
                  max: 50,
                  onChanged: (val) {
                    setState(() {
                      value = val.ceilToDouble();
                      // widget.onSet(value);
                    });
                  },
                  value: value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistanceButton extends StatelessWidget {
  const _DistanceButton({
    Key? key,
    required this.widget,
    required this.value,
  }) : super(key: key);

  final DistanceSlider widget;
  final double value;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(153, 47, 115, 100)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: Color.fromARGB(255, 5, 0, 0)),
            ),
          ),
        ),
        child: const Text(
          "Zatwierdź",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        onPressed: () => widget.onSet(value));
  }
}
