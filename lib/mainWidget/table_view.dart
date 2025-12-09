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
import 'package:flutter_proyect/utils/edit_products_form.dart';
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
  List<ProductTypesTableData> productTypes = [];
  List<ProductsClassData> products = [];
  int _selectedType = 99;
  @override
  void initState() {
    super.initState();
    getLines();
    getProductTypes();
    getProducts();
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

  Future<void> getProductTypes() async {
    final response = await database.select(database.productTypesTable).get();
    setState(() {
      productTypes = response;
    });
  }

  Future<void> getProducts() async {
    final response = await database.select(database.productsClass).get();
    setState(() {
      products = response;
    });
  }

  void _selectType(int type) {
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

  void onEditProductType(ProductTypesTableData productType) async {
    final Map<String, dynamic> result = await showDialog(
      context: context,
      builder: (context) => EditTypesForm(product: productType),
    );
    if (result[""] != "") {
      await database
          .update(database.productTypesTable)
          .replace(ProductTypesTableData.fromJson(result));
      final updatedDB = await database.select(database.productTypesTable).get();
      setState(() {
        productTypes = updatedDB;
      });
    } else {
      await (database.delete(
        database.productTypesTable,
      )..where((e) => e.id.isValue(productType.id))).go();
      final updatedDB = await database.select(database.productTypesTable).get();
      setState(() {
        productTypes = updatedDB;
      });
    }
  }

  void onAddProductType() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddTypesForm(),
    );

    if (result != {}) {
      await database.into(database.productTypesTable).insert(result);
      final updatedDB = await database.select(database.productTypesTable).get();

      setState(() {
        productTypes = updatedDB;
      });
    }
  }

  void onEditProduct(ProductsClassData product) async {
    final Map<String, dynamic> result = await showDialog(
      context: context,
      builder: (context) => EditProductsForm(product: product),
    );

    if (result[""] != "") {
      await database
          .update(database.productsClass)
          .replace(ProductsClassData.fromJson(result));
      final updatedDB = await database.select(database.productsClass).get();
      setState(() {
        products = updatedDB;
      });
    } else {
      await (database.delete(
        database.productsClass,
      )..where((e) => e.id.isValue(product.id))).go();
      final updatedDB = await database.select(database.productsClass).get();
      setState(() {
        products = updatedDB;
      });
    }
  }

  void onAddProduct() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProductsForm(),
    );

    if (result != {}) {
      await database.into(database.productsClass).insert(result);
      final updatedDB = await database.select(database.productsClass).get();
      setState(() {
        products = updatedDB;
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
                          child: ProductTypes(
                            productTypesList: productTypes,
                            onSelectType: _selectType,
                            onEditType: onEditProductType,
                            onAddType: onAddProductType,
                          ),
                        ),
                        Flexible(
                          child: Products(
                            productsList: products.where(
                              (e) => e.type == _selectedType,
                            ).toList(),
                            onEditProduct: onEditProduct,
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
