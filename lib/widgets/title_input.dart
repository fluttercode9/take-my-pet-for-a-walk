import 'package:flutter/material.dart';
import '../screens/add_event_screen.dart';

class TitleInput extends StatelessWidget {
  final Function changeState;
  final Function editEvent;
  const TitleInput({
    Key? key,
    required this.changeState,
    required this.editEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            onSaved: (val) {
              editEvent(title: val);
            },
            validator: (value) {
              if (value == null || value.isEmpty || value == "") {
                changeState(StepState.error, FormSteps.title);
                return "Wprowadź tytuł";
              }
              changeState(StepState.complete, FormSteps.title);
              return null;
            },
            decoration: InputDecoration(labelText: 'Tytuł')),
      ],
    );
  }
}
