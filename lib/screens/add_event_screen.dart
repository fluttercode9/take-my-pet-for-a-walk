import 'dart:io';

import 'package:flutter/material.dart';
import 'package:okolicznie/helpers/db_helper.dart';
import 'package:okolicznie/widgets/image_input.dart';
import 'package:okolicznie/widgets/title_input.dart';
import 'package:okolicznie/widgets/location_input.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/events.dart';
import '../widgets/confirm_button.dart';
import '../widgets/desc_input.dart';

enum FormSteps { title, desc, image, location }

class AddEventScreen extends StatefulWidget {
  AddEventScreen({Key? key}) : super(key: key);
  static const route = 'add-event';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  File? _image;
  Event _editedEvent = Event(
      ownerId: DBhelper.auth.currentUser!.uid,
      description: "",
      id: DateTime.now.toString(),
      imageUrl: "",
      title: "",
      location: EventLocation(latitude: 0, longitude: 0, address: ""));
  var _titleState = StepState.indexed;
  var _descState = StepState.indexed;
  var _imageState = StepState.indexed;
  var _locationState = StepState.indexed;
  int _index = 0;
  final _formKey = GlobalKey<FormState>();
  Future<void> _saveEvent() async {
    if (_editedEvent.title == null ||
        _editedEvent.description == null ||
        _editedEvent.location == null ||
        _image == null) {
      print(
          'nie udalo sie dodaj text do walidacji etc lokalizacji, stan steppera etc');
      return;
    }
    await Provider.of<Events>(context, listen: false)
        .addEvent(_editedEvent, _image!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var stepsList = <Step>[
      Step(
        state: _titleState,
        isActive: _index > 0,
        title: const Text('Tytuł'),
        content: TitleInput(editEvent: _editEvent, changeState: _changeState),
      ),
      Step(
        state: _descState,
        isActive: _index > 1,
        title: const Text('Opis'),
        content: DescInput(
          editEvent: _editEvent,
          changeState: _changeState,
        ),
      ),
      Step(
        state: _imageState,
        isActive: _index > 2,
        title: const Text('Zdjęcie'),
        content: ImageInput(
          editImage: _editImage,
          changeState: _changeState,
        ),
      ),
      Step(
        state: _locationState,
        isActive: _index > 3,
        title: Text('Lokacja'),
        content:
            LocationInput(editEvent: _editEvent, changeState: _changeState),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj zwierzę'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          onStepTapped: (step) => setState(() {
            _index = step;
          }),
          physics: ClampingScrollPhysics(),
          steps: stepsList,
          currentStep: _index,
          onStepContinue: onStepContinue,
          onStepCancel: onStepCancel,
          controlsBuilder: (context, details) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _index == 0
                    ? Container()
                    : TextButton(
                        onPressed: onStepCancel,
                        child: const Text('Cofnij'),
                      ),
                _index != 3
                    ? ConfirmButton(
                        title: 'Dalej',
                        fontSize: 15,
                        height: 30,
                        width: 100,
                        onPressed: onStepContinue,
                      )
                    : ConfirmButton(
                        title: 'Zatwierdź',
                        fontSize: 15,
                        height: 40,
                        width: 200,
                        onPressed: _saveForm,
                      )
              ],
            );
          },
        ),
      ),
    );
  }

  void onStepCancel() {
    if (_index > 0) {
      setState(() {
        _index--;
      });
    }
  }

  void onStepContinue() {
    if (_index < 3) {
      setState(() {
        _index++;
      });
    }
  }

  void increment() {
    _index++;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      _formKey.currentState!.save();
      _saveEvent();
    } else {
      print('nie udalo sie');
    }
  }

  void _editImage(File image) {
    _image = image;
  }

  void _editEvent(
      {id = null,
      location = null,
      imageUrl = null,
      description = null,
      title = null}) {
    _editedEvent = _editedEvent.copyWith(
        description: description,
        id: id,
        imageUrl: imageUrl,
        location: location,
        title: title);
    print(
        '${_editedEvent.title}xxx${_editedEvent.description}xxx${_editedEvent.location.latitude}${_editedEvent.location.address}');
  }

  void _changeState(StepState newState, FormSteps step) {
    setState(() {
      //mozna zrobic casy
      if (step == FormSteps.title) {
        _titleState = newState;
      }
      if (step == FormSteps.desc) {
        _descState = newState;
      }
      if (step == FormSteps.image) {
        _imageState = newState;
      }
      if (step == FormSteps.location) {
        _locationState = newState;
      }
    });
  }
}
