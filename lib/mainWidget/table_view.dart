import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';
import 'package:flutter_proyect/mainWidget/table_view/edit_product.dart';
import 'package:flutter_proyect/mainWidget/table_view/keyboard.dart';
import 'package:flutter_proyect/mainWidget/table_view/product_list.dart';
import 'package:flutter_proyect/mainWidget/table_view/product_types.dart';
import 'package:flutter_proyect/mainWidget/table_view/products.dart';
import 'package:flutter_proyect/utils/add_products_form.dart';
import 'package:flutter_proyect/utils/print/print_ticket.dart';
import 'package:flutter_proyect/utils/add_types_form.dart';
import 'package:flutter_proyect/utils/checkout.dart';
import 'package:flutter_proyect/utils/db_updates.dart';
import 'package:flutter_proyect/utils/edit_products_form.dart';
import 'package:flutter_proyect/utils/edit_types_form.dart';
import 'package:flutter_proyect/utils/free_price_form.dart';
import 'package:flutter_proyect/utils/split_table.dart';
import 'package:flutter_proyect/utils/config.dart' as config;

class TableView extends StatefulWidget {
  const TableView({super.key, required this.mesa});
  final RestTable mesa;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  List<OrderLine> orderLines = [];
  List<ProductTypesTableData> productTypes = [];
  List<ProductsClassData> products = [];
  int _selectedType = 99;
  String priceText = "";
  Map<String, dynamic> _editedProduct = {};
  final GlobalKey<KeyboardState> keyboardKey = GlobalKey<KeyboardState>();
  @override
  void initState() {
    super.initState();
    getLines();
    getProductTypes();
    getProducts();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ***GETTERS***

  Future<void> getLines() async {
    final response =
        await (database.select(database.orderLines).join([
              drift.innerJoin(
                database.orders,
                database.orders.id.equalsExp(database.orderLines.order),
              ),
            ])..where(
              database.orders.restTable.equals(widget.mesa.id) &
                  database.orders.closedAt.isNull(),
            ))
            .get();
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

  // ***************************************
  // ***PRODUCT TYPE RELATED***
  void _selectType(int type) {
    setState(() {
      _selectedType = type;
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

  // ***************************************************
  // ***PRODUCT RELATED***
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

  void onTapProduct(ProductsClassData producto) async {
    double price = double.parse(producto.price.toStringAsFixed(2));
    OrderLine returnedOrder;
    if (priceText != "") {
      price = double.parse(priceText);
    }
    final List<Order> orderFromTable =
        await (database.select(database.orders)..where((e) {
              return e.restTable.isValue(widget.mesa.id) & e.closedAt.isNull();
            }))
            .get();
    final bool isNewProduct = orderLines.every((e) {
      return (e.productName == producto.name && e.currentPrice != price) ||
          (e.productName != producto.name);
    });
    final Taxe taxRate = await (database.select(
      database.taxes,
    )..where((e) => e.id.isValue(producto.taxes))).getSingle();
    if (orderFromTable.isEmpty && isNewProduct) {
      final Order newOrder = await database
          .into(database.orders)
          .insertReturning(
            OrdersCompanion.insert(
              totalPrice: price,
              payedPrice: 0,
              totalTaxes: taxRate.rate * price,
              //TODO: Rename totalPriceWithTaxes to totalPriceWithoutTaxes
              totalPriceWithTaxes: (1 - taxRate.rate) * price,
              state: 0,
              restTable: widget.mesa.id,
            ),
          );
      returnedOrder = await database
          .into(database.orderLines)
          .insertReturning(
            OrderLinesCompanion.insert(
              productName: producto.name,
              currentPrice: price,
              totalPrice: price,
              taxRate: taxRate.rate,
              taxPrice: taxRate.rate * price,
              quantity: 1,
              order: newOrder.id,
            ),
          );
    } else if (isNewProduct) {
      returnedOrder = await database
          .into(database.orderLines)
          .insertReturning(
            OrderLinesCompanion.insert(
              productName: producto.name,
              currentPrice: price,
              totalPrice: price,
              taxRate: 0.2,
              taxPrice: (price * 0.20),
              quantity: 1,
              order: orderFromTable.last.id,
            ),
          );
    } else {
      OrderLine oldProduct = orderLines.firstWhere(
        (e) => e.productName == producto.name && e.currentPrice == price,
      );
      OrderLine newProduct = oldProduct.copyWith(
        quantity: oldProduct.quantity + 1,
        totalPrice: oldProduct.currentPrice + oldProduct.totalPrice,
        taxPrice:
            (oldProduct.totalPrice + oldProduct.currentPrice) *
            oldProduct.taxRate,
      );
      await database.update(database.orderLines).replace(newProduct);
    }
    keyboardKey.currentState?.onClearInput();

    await DbUpdates.updatedOrders(widget.mesa.id);

    await getLines();
  }

  // ****************************************************

  // ***PRODUCT LIST RELATED***
  void onEditProductList(Map<String, dynamic> product) {
    setState(() {
      _editedProduct = product;
    });
  }

  void onSaveEditProductList() async {
    final oldProduct = OrderLine.fromJson(_editedProduct);
    final Map<String, dynamic> result = await showDialog(
      context: context,
      builder: (context) => FreePriceForm(),
    );

    if (result["price"] != "0") {
      final newProduct = oldProduct.copyWith(
        currentPrice: double.parse(result["price"]),
        taxRate: oldProduct.taxRate,
        taxPrice: (oldProduct.taxRate * double.parse(result["price"])),
        totalPrice: double.parse(result["price"]) * oldProduct.quantity,
      );
      await database.update(database.orderLines).replace(newProduct);
    }
    await DbUpdates.updatedOrders(oldProduct.order);
    getLines();
  }

  void onCancelEditProductList() {
    setState(() {
      _editedProduct = {};
    });
  }

  void onRemoveProductFromList(Map<String, dynamic> removedProduct) async {
    final orderLine = orderLines.elementAt(
      orderLines.indexOf(OrderLine.fromJson(removedProduct)),
    );
    await (database.delete(
      database.orderLines,
    )..where((e) => e.id.isValue(orderLine.id))).go();
    getLines();
    await DbUpdates.updatedOrders(widget.mesa.id);
    setState(() {
      _editedProduct = {};
    });
  }

  void onAddProductUnitFromList(Map<String, dynamic> addUnit) async {
    await (database.update(
      database.orderLines,
    )..where((e) => e.id.isValue(addUnit["id"]))).write(
      OrderLinesCompanion.custom(
        quantity: database.orderLines.quantity + const drift.Constant(1),
        totalPrice:
            database.orderLines.totalPrice + database.orderLines.currentPrice,
        taxPrice:
            database.orderLines.taxPrice +
            (database.orderLines.taxRate * database.orderLines.currentPrice),
      ),
    );
    await DbUpdates.updatedOrders(widget.mesa.id);
    getLines();
  }

  void onRemoveProductUnitFromList(Map<String, dynamic> addUnit) async {
    if (addUnit["quantity"] > 1) {
      await (database.update(
        database.orderLines,
      )..where((e) => e.id.isValue(addUnit["id"]))).write(
        OrderLinesCompanion.custom(
          quantity: database.orderLines.quantity - const drift.Constant(1),
          totalPrice:
              database.orderLines.totalPrice - database.orderLines.currentPrice,
          taxPrice:
              database.orderLines.taxPrice -
              (database.orderLines.taxRate * database.orderLines.currentPrice),
        ),
      );
    } else {
      await (database.delete(
        database.orderLines,
      )..where((e) => e.id.isValue(addUnit["id"]))).go();
      setState(() {
        _editedProduct = {};
      });
    }

    await DbUpdates.updatedOrders(widget.mesa.id);
    getLines();
  }

  // *******************************
  // ***Keyboard Related***
  void onChangePriceText(String priceLabel) {
    setState(() {
      priceText = priceLabel;
    });
  }

  void onCheckout() async {
    DbUpdates.updatedOrders(widget.mesa.id);
    final List<Order> result = await showDialog(
      context: context,
      builder: (context) => Checkout(mesaID: widget.mesa.id),
    );
    getLines();
    DbUpdates.updatedOrders(widget.mesa.id);
    if (result.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  void onSplitTable() async {
    await DbUpdates.updatedOrders(widget.mesa.id);
    final result = await showDialog(
      context: context,
      builder: (context) => SplitTable(mesa: widget.mesa),
    );
    getLines();
    await DbUpdates.updatedOrders(widget.mesa.id);
  }

  void onDeleteTable() async {
    final result =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Estas seguro que deseas borrar la mesa?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
                child: Text(
                  'Si',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ) ??
        0;
    if (result == 1 && context.mounted) {
      await (database.delete(database.orderLines)..where(
            (e) => e.id.isIn(orderLines.map((line) => line.id).toList()),
          ))
          .go();
      await DbUpdates.updatedOrders(widget.mesa.id);
      Navigator.of(context).pop();
    }
  }

  // *** Print Related ***
  Future onPrintReceive() async {
    await printReceive(orderLines, widget.mesa.number);
  }

  // Printer Type [bluetooth, usb, network]
  // *******************************

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
                  Expanded(
                    child: ProductList(
                      items: orderLines,
                      onSelectProduct: onEditProductList,
                      mesa: widget.mesa.number,
                    ),
                  ),
                  Flexible(
                    child: Keyboard(
                      key: keyboardKey,
                      onChangePriceText: onChangePriceText,
                      onEnter: onTapProduct,
                      onCheckout: onCheckout,
                      onDeleteTable: onDeleteTable,
                      onSplitTable: onSplitTable,
                      onPrintReceive: onPrintReceive,
                    ),
                  ),
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
                        Visibility(
                          visible: _selectedType != 99,
                          child: Flexible(
                            child: Products(
                              productsList: products
                                  .where((e) => e.type == _selectedType)
                                  .toList(),
                              onEditProduct: onEditProduct,
                              onAddProduct: onAddProduct,
                              onTapProduct: onTapProduct,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return EditProduct(
                    product: _editedProduct,
                    onSaveProduct: onSaveEditProductList,
                    onCancelEdit: onCancelEditProductList,
                    onRemoveProduct: onRemoveProductFromList,
                    onAddProductUnit: onAddProductUnitFromList,
                    onRemoveProductUnit: onRemoveProductUnitFromList,
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
