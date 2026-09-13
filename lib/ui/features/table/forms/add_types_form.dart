import 'package:flutter/material.dart';

class AddTypesFormResponse {
  final bool isCancelled;
  final String? productName;
  final String? productColor;
  final int? productOrder;

  AddTypesFormResponse({
    this.isCancelled = false,
    this.productName,
    this.productColor,
    this.productOrder,
  });
}

class AddTypesForm extends StatefulWidget {
  const AddTypesForm({super.key});

  @override
  State<AddTypesForm> createState() => _AddTypesFormState();
}

class _AddTypesFormState extends State<AddTypesForm> {
  String name = "";

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
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nombre",
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onChanged: (text) {
                name = text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el nombre';
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
            Navigator.of(context).pop(AddTypesFormResponse(isCancelled: true));
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final AddTypesFormResponse response = AddTypesFormResponse(
              isCancelled: false,
              productName: name,
              productColor: "",
              productOrder: 0,
            );
            Navigator.of(context).pop(response);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
