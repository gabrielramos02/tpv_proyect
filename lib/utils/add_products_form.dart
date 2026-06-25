import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';

class AddProductsForm extends StatefulWidget {
  const AddProductsForm({super.key, required this.selectedFamily});
  final int selectedFamily;

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
      title: Text('Producto'),
      content: Form(
        key: _formKey,
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
              hint: Text("Familia"),
              initialValue: widget.selectedFamily,
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
              validator: (value) {
                if (value == null || value == 0) {
                  return 'Selecciona la familia';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              isExpanded: true,
              hint: Text("Selecciona el tipo de taxes"),
              initialValue: taxes[0].id,
              items: taxes.map((index) {
                return DropdownMenuItem(
                  value: index.id,
                  child: Text(index.name),
                );
              }).toList(),
              onChanged: (e) {
                taxRate = e;
              },
              validator: (value) {
                if (value == null || value == 0) {
                  return 'Selecciona un tipo de impuesto';
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
            Navigator.of(context).pop({});
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final ProductsClassCompanion response =
                  ProductsClassCompanion.insert(
                    name: name,
                    price: double.parse(price),
                    color: "",
                    order: 0,
                    type: type as int,
                    taxes: taxRate as int,
                  );
              Navigator.of(context).pop(response);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
