import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';
import 'package:flutter_proyect/mainWidget/table_view/edit_product.dart';
import 'package:flutter_proyect/mainWidget/table_view/keyboard.dart';
import 'package:flutter_proyect/mainWidget/table_view/product_list.dart';
import 'package:flutter_proyect/mainWidget/table_view/product_types.dart';
import 'package:flutter_proyect/mainWidget/table_view/products.dart';
import 'package:flutter_proyect/utils/add_products_form.dart';
import 'package:flutter_proyect/utils/add_types_form.dart';
import 'package:flutter_proyect/utils/edit_types_form.dart';

final List<Map<String, dynamic>> items = [
  {'producto': 'Laptop', 'cantidad': 2, 'precio': 1200},
  {'producto': 'Mouse', 'cantidad': 5, 'precio': 25},
];
final List<Map<String, dynamic>> productTypes = [
  {'nombre': 'Cafes'},
  {'nombre': 'Bebidas'},
];
final List<Map<String, dynamic>> products = [
  {'nombre': 'Cortado', 'familia': 'Cafes'},
  {'nombre': 'Refresco', 'familia': 'Bebidas'},
];

class TableView extends StatefulWidget {
  const TableView({super.key, required this.mesa});
  final String mesa;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  List<OrderLine> orderLines = [];
  String _selectedType = "";
  @override
  @override
  void initState() {
    super.initState();
    getLines();
  }

  Future<void> getLines() async {
    final response = await (database.select(database.orderLines).join([
      drift.innerJoin(
        database.orders,
        database.orders.id.equalsExp(database.orderLines.id),
      ),
    ])..where(database.orders.name.equals(widget.mesa))).get();
    final result = response
        .map((row) => row.readTable(database.orderLines))
        .toList();

    setState(() {
      orderLines = result;
    });
  }

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  Map<String, dynamic> _editedProduct = {};
  void onEditProductList(Map<String, dynamic> product) {
    setState(() {
      _editedProduct = product;
    });
  }

  Future<void> onSaveEdit(Map<String, dynamic> updatedProduct) async {
    await database
        .update(database.orderLines)
        .replace(OrderLine.fromJson(updatedProduct));
final updatedDB = await database.select(database.orderLines).get();
    setState(() {
        orderLines = updatedDB;
      _editedProduct = updatedProduct;
    });
    print(items);
  }

  void onCancelEdit() {
    setState(() {
      _editedProduct = {};
    });
  }

  void onRemoveProduct(Map<String, dynamic> removedProduct) {
    setState(() {
      items.remove(removedProduct);
      _editedProduct = {};
    });
  }

  void onAddProductUnit(Map<String, dynamic> addUnit) {
    setState(() {
      items[items.indexOf(addUnit)]["cantidad"]++;
    });
  }

  void onRemoveProductUnit(Map<String, dynamic> addUnit) {
    setState(() {
      items[items.indexOf(addUnit)]["cantidad"]--;
    });
  }

  void onEditProductType(Map<String, dynamic> product) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditForm(productType: product),
    );

    if (result.isNotEmpty) {
      print('Datos recibidos: ${result["nombre"]}');
      setState(() {
        productTypes.remove(product);
        productTypes.add(result);
      });
    } else {
      setState(() {
        productTypes.remove(product);
      });
    }
  }

  void onAddProductType() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddTypesForm(),
    );

    if (result.isNotEmpty) {
      print('Datos recibidos: ${result["nombre"]}');
      setState(() {
        productTypes.add(result);
      });
    }
  }

  void onEditProduct(Map<String, dynamic> product) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditForm(productType: product),
    );

    if (result.isNotEmpty) {
      setState(() {
        products.remove(product);
        products.add(result);
      });
    } else {
      setState(() {
        products.remove(product);
      });
    }
  }

  void onAddProduct() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProductsForm(),
    );

    if (result.isNotEmpty) {
      print('Datos recibidos: ${result["nombre"]}');
      setState(() {
        products.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Row(
          children: [
            Flexible(
              child: Column(
                children: [
                  Flexible(
                    child: ProductList(
                      items: orderLines,
                      onSelectProduct: onEditProductList,
                      mesa: widget.mesa,
                    ),
                  ),
                  Flexible(child: Keyboard()),
                ],
              ),
            ),
            Flexible(
              child: Builder(
                builder: (context) {
                  if (_editedProduct.isEmpty) {
                    return Column(
                      children: [
                        Flexible(
                        //TODO: all functions to Tables
                          child: ProductTypes(
                            productTypesList: productTypes,
                            onSelectType: _selectType,
                            onEditType: onEditProductType,
                            onAddType: onAddProductType,
                          ),
                        ),
                        Flexible(
                        //TODO: all functions to Tables
                          child: Products(
                            productsList: products.toList().where((index) {
                              return index["familia"] == _selectedType;
                            }).toList(),
                            onEditType: onEditProduct,
                            onAddProduct: onAddProduct,
                          ),
                        ),
                      ],
                    );
                  }
                  return EditProduct(
                    product: _editedProduct,
                    onSaveProduct: onSaveEdit,
                    onCancelEdit: onCancelEdit,
                    onRemoveProduct: onRemoveProduct,
                    onAddProductUnit: onAddProductUnit,
                    onRemoveProductUnit: onRemoveProductUnit,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
