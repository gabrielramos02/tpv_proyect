import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';

class EditTypesForm extends StatefulWidget {
  const EditTypesForm({super.key, required this.product});
  final ProductTypesTableData product;

  @override
  State<EditTypesForm> createState() => _EditTypesFormState();
}

class _EditTypesFormState extends State<EditTypesForm> {
  Map<String, dynamic> response = {};
  @override
  void initState() {
    super.initState();
    response = widget.product.toJson();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(widget.product.name),
      content: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.product.name,
              decoration: InputDecoration(
                labelText: "Nombre",
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onChanged: (text) {
                response["name"] = text;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un nombre';
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
            Navigator.of(context).pop({"": ""});
          },
          child: const Text('Eliminar'),
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
