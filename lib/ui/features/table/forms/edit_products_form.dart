import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:provider/provider.dart';

class EditProductsFormResponse {
  final bool isDeleted;
  String? name;
  double? price;
  int? type;
  int? taxes;
  int? order;
  String? color;
  EditProductsFormResponse({
    required this.isDeleted,
    this.name,
    this.price,
    this.type,
    this.taxes,
    this.order,
    this.color,
  });
}

class EditProductsForm extends StatefulWidget {
  const EditProductsForm({super.key, required this.product});
  final ProductsClassData product;

  @override
  State<EditProductsForm> createState() => _EditProductsFormState();
}

class _EditProductsFormState extends State<EditProductsForm> {
  late final ProductRepository _productRepository = ProductRepository(
    context.read<DatabaseService>().database,
  );
  List<ProductTypesTableData> productTypes = [];
  List<Taxe> taxes = [];
  late EditProductsFormResponse response;
  @override
  @override
  void initState() {
    super.initState();
    response = EditProductsFormResponse(
      isDeleted: false,
      name: widget.product.name,
      order: widget.product.order,
      price: widget.product.price,
      type: widget.product.type,
      taxes: widget.product.taxes,
      color: widget.product.color,
    );
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
              initialValue: widget.product.price.toString(),
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
                response.type = e;
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
                response.taxes = e;
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
            ).pop(EditProductsFormResponse(isDeleted: true));
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
