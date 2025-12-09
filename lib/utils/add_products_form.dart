import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';

class AddProductsForm extends StatefulWidget {
  const AddProductsForm({super.key});

  @override
  State<AddProductsForm> createState() => _AddProductsFormState();
}

class _AddProductsFormState extends State<AddProductsForm> {
  Map<String, dynamic> response = {};
  List<ProductTypesTableData> productTypes = [];
  List<Taxe> taxes = [];
  String name = "";
  String price = "";
  int? type = 0;
  int? taxRate = 0;
  @override
  void initState() {
    super.initState();
    getTypes();
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
                  return 'Ingresa un nombre';
                }
                return null;
              },
            ),
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
                  return 'Ingresa un precio';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              hint: Text("Selecciona la familia"),
              isExpanded: true,
              items: productTypes.map((index) {
                return DropdownMenuItem(
                  value: index.id,
                  child: Text(index.name),
                );
              }).toList(),
              onChanged: (e) {
                type = e;
              },
            ),
            DropdownButtonFormField(
              isExpanded: true,
              hint: Text("Selecciona el tipo de taxes"),
              items: taxes.map((index) {
                return DropdownMenuItem(
                  value: index.id,
                  child: Text(index.name),
                );
              }).toList(),
              onChanged: (e) {
                taxRate = e;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(Map());
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final ProductsClassCompanion response =
                ProductsClassCompanion.insert(
                  name: name,
                  price: double.parse(price),
                  color: "",
                  order: 0,
                  type: type as int,
                  taxes: 0,
                );
            Navigator.of(context).pop(response);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
