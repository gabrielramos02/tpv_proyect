import 'package:flutter/material.dart';

/// Result returned by [FreePriceForm] when the user confirms a price.
class FreePriceResult {
  const FreePriceResult({required this.price});

  final String price;
}

class FreePriceForm extends StatefulWidget {
  const FreePriceForm({super.key});

  @override
  State<FreePriceForm> createState() => _FreePriceFormState();
}

class _FreePriceFormState extends State<FreePriceForm> {
  String price = "";

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
            Navigator.of(context).pop(const FreePriceResult(price: '0'));
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(FreePriceResult(price: price));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
