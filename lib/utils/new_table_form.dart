import 'package:flutter/material.dart';

class NewTableForm extends StatefulWidget {
  const NewTableForm({super.key});

  @override
  State<NewTableForm> createState() => _NewTableFormState();
}

class _NewTableFormState extends State<NewTableForm> {
  String number = "";

  final Map<String, dynamic> response = {"price": "0"};
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text('Precio Libre'),
      content: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nueva Mesa",
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onChanged: (text) {
                number = text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el numero de mesa';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop("");
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(number);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
