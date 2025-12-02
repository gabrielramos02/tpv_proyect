import 'package:flutter/material.dart';
List fields = ["nombre","familia"];

class AddProductsForm extends StatefulWidget {
  const AddProductsForm({super.key,});

  @override
  State<AddProductsForm> createState() => _AddProductsFormState();
}

class _AddProductsFormState extends State<AddProductsForm> {
  Map<String, dynamic> response = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text('Familia'),
      content: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...fields.map((index) {
              return TextFormField(
                decoration: InputDecoration(
                  labelText: index.toUpperCase(),
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                onChanged: (text) {
                  response.addAll({index:text});
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
