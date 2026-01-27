import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';

class EditProductsForm extends StatefulWidget {
  const EditProductsForm({super.key, required this.product});
  final ProductsClassData product;

  @override
  State<EditProductsForm> createState() => _EditProductsFormState();
}

class _EditProductsFormState extends State<EditProductsForm> {
  List<ProductTypesTableData> productTypes = [];
  List<Taxe> taxes = [];
  Map<String, dynamic> response = {};
  @override
  @override
  void initState() {
    super.initState();
    response = widget.product.toJson();
    getTypes();
    getTaxes();
  }

  Future<void> getTypes() async {
    final response = await database.select(database.productTypesTable).get();
    setState(() {
      productTypes = response;
    });
  }

  Future<void> getTaxes() async {
    final response = await database.select(database.taxes).get();
    setState(() {
      taxes = response;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(widget.product.name),
      content: Form(
        key: _formKey,
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
            TextFormField(
              initialValue: widget.product.price.toString(),
              decoration: InputDecoration(
                labelText: "Precio",
                labelStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onChanged: (text) {
                response["price"] = double.parse(text);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un precio';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              initialValue: widget.product.type,
              hint: Text("Selecciona la familia"),
              isExpanded: true,
              items: productTypes.map((index) {
                return DropdownMenuItem(
                  value: index.id,
                  child: Text(index.name),
                );
              }).toList(),
              onChanged: (e) {
                response["type"] = e;
              },
            ),
            DropdownButtonFormField(
              initialValue: widget.product.taxes,
              isExpanded: true,
              hint: Text("Selecciona el tipo de taxes"),
              items: taxes.map((index) {
                return DropdownMenuItem(
                  value: index.id,
                  child: Text(index.name),
                );
              }).toList(),
              onChanged: (e) {
                response["taxes"] = e;
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
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(response);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
