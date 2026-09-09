import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:provider/provider.dart';

class AddProductsFormResponse {
  final bool isCancelled;
  String? name;
  double? price;
  int? type;
  int? taxes;
  int? order;
  String? color;
  AddProductsFormResponse({
    required this.isCancelled,
    this.name,
    this.price,
    this.type,
    this.taxes,
    this.order,
    this.color,
  });
}

class AddProductsForm extends StatefulWidget {
  const AddProductsForm({super.key, required this.selectedFamily});
  final int selectedFamily;

  @override
  State<AddProductsForm> createState() => _AddProductsFormState();
}

class _AddProductsFormState extends State<AddProductsForm> {
  late final _productRepository = ProductRepository(
    context.read<DatabaseService>().database,
  );
  late AddProductsFormResponse response = AddProductsFormResponse(
    isCancelled: false,
  );
  List<ProductTypesTableData> productTypes = [];
  List<Taxe> taxes = [];
  @override
  void initState() {
    super.initState();
    getTypes();
    getTaxes();
  }

  Future<void> getTypes() async {
    final response = await _productRepository.getProductTypes();
    setState(() {
      productTypes = response;
    });
  }

  Future<void> getTaxes() async {
    final response = await _productRepository.getTaxes();
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
      content: productTypes.isEmpty || taxes.isEmpty
          ? const SizedBox(
              width: 200,
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
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
                      response.name = text;
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
                      response.price = double.parse(text);
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
                    initialValue:
                        productTypes.any((t) => t.id == widget.selectedFamily)
                        ? widget.selectedFamily
                        : null,
                    isExpanded: true,
                    items: productTypes.map((index) {
                      return DropdownMenuItem(
                        value: index.id,
                        child: Text(index.name),
                      );
                    }).toList(),
                    onChanged: (e) {
                      response.type = e;
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
                      response.taxes = e;
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
            Navigator.of(
              context,
            ).pop(AddProductsFormResponse(isCancelled: true));
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              response.type ??= widget.selectedFamily;
              response.taxes ??= taxes.isNotEmpty ? taxes[0].id : null;
              Navigator.of(context).pop(response);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
