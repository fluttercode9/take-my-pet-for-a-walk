import 'package:flutter/material.dart';
import 'package:okolicznie/screens/add_event_screen.dart';

class DescInput extends StatelessWidget {

  final Function changeState;
  final Function editEvent;
  const DescInput({
    Key? key,

    required this.changeState, required this.editEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          minLines: 10,
          maxLines: 30,
          onSaved:(val) => editEvent(description: val ),
            validator: (value) {
              if (value == null || value.isEmpty || value == "") {
                changeState(StepState.error, FormSteps.desc);
                return "Wprowadź opis!";
              }
              changeState(StepState.complete, FormSteps.desc);
              return null;
            },

            decoration: InputDecoration(labelText: 'Opis')),
      ],
    );
  }
}
