import 'package:flutter/material.dart';

class FreePriceForm extends StatefulWidget {
  const FreePriceForm({super.key});

  @override
  State<FreePriceForm> createState() => _FreePriceFormState();
}

class _FreePriceFormState extends State<FreePriceForm> {
  String price = "";

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
                labelText: "Precio",
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onChanged: (text) {
                price = text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el precio';
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
            Navigator.of(context).pop(response);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
              response["price"]= price;
            Navigator.of(context).pop(response);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
