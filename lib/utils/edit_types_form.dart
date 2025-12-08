import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key, required this.productType});
  final Map productType;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  Map response = {};

  @override
  Widget build(BuildContext context) {
    response = widget.productType;
    return AlertDialog(
    actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text('${widget.productType["nombre"]}'),
      content: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.productType.entries.map((index) {
              return TextFormField(
                decoration: InputDecoration(
                  labelText: index.key.toUpperCase(),
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                initialValue: index.value,
                onChanged: (text) {
                  response.update(index.key, (value) {
                    return text;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un nombre';
                  }
                  return null;
                },
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(Map());
          },
          child: const Text('Remove'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(response);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
