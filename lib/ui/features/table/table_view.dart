import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/printer/print_ticket.dart';
import 'package:flutter_proyect/ui/core/widgets/edit_product.dart';
import 'package:flutter_proyect/ui/core/widgets/keyboard.dart';
import 'package:flutter_proyect/ui/core/widgets/product_list.dart';
import 'package:flutter_proyect/ui/core/widgets/product_types.dart';
import 'package:flutter_proyect/ui/core/widgets/products.dart';
import 'package:flutter_proyect/ui/features/table/checkout.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/free_price_form.dart';
import 'package:flutter_proyect/ui/features/table/split_table.dart';
import 'package:provider/provider.dart';

class TableView extends StatefulWidget {
  const TableView({super.key, required this.mesa});
  final RestTable mesa;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late final _orderRepository = OrderRepository(
    context.read<DatabaseService>().database,
  );
  AppDatabase get database => context.read<DatabaseService>().database;
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
    final List<OrderLine> result = await _orderRepository.getLines(
      widget.mesa.id,
    );
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
      builder: (context) => AddProductsForm(selectedFamily: _selectedType),
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
    if (priceText != "") {
      price = double.parse(priceText);
    }
    final List<Order> orderFromTable = await _orderRepository.getOrders(
      widget.mesa.id,
    );
    // Add to product repo
    final bool isNewProduct = orderLines.every((e) {
      return (e.productName == producto.name && e.currentPrice != price) ||
          (e.productName != producto.name);
    });
    final Taxe taxRate = await (database.select(
      database.taxes,
    )..where((e) => e.id.isValue(producto.taxes))).getSingle();
    if (orderFromTable.isEmpty && isNewProduct) {
      final Order newOrder = await _orderRepository.addNewOrder(
        widget.mesa.id,
        price,
        taxRate.rate,
      );
      await _orderRepository.addNewOrderLine(
        newOrder.id,
        producto.id,
        price,
        taxRate.rate,
        producto.name,
      );
    } else if (isNewProduct) {
      await _orderRepository.addNewOrderLine(
        orderFromTable.last.id,
        producto.id,
        price,
        taxRate.rate,
        producto.name,
      );
    } else {
      OrderLine product = orderLines.firstWhere(
        (e) => e.productName == producto.name && e.currentPrice == price,
      );
      await _orderRepository.updateOrderLineQuantity(
        product,
        product.quantity + 1,
      );
    }
    keyboardKey.currentState?.onClearInput();

    await _orderRepository.updateOrders(widget.mesa.id);

    await getLines();
  }

  // ****************************************************

  // ***PRODUCT LIST RELATED***
  void onEditProductList(Map<String, dynamic> product) {
    setState(() {
      _editedProduct = product;
    });
  }

// TODO: Find why the checkout total price is not updating when changing the price of a product
  void onSaveEditProductList() async {
    final oldProduct = OrderLine.fromJson(_editedProduct);
    final FreePriceResult? result = await showDialog<FreePriceResult>(
      context: context,
      builder: (context) => FreePriceForm(),
    );

    if (result?.price != "0") {
      await _orderRepository.updateOrderLinePrice(
        oldProduct,
        double.parse(result!.price),
      );
    }
    await _orderRepository.updateOrders(oldProduct.order);
    getLines();
    setState(() {
    });
  }

  void onCancelEditProductList() {
    setState(() {
      _editedProduct = {};
    });
  }

  // TODO: Find better way to do this, i dont like how gets the index of the product
  void onRemoveProductFromList(Map<String, dynamic> removedProduct) async {
    final orderLine = orderLines.elementAt(
      orderLines.indexOf(OrderLine.fromJson(removedProduct)),
    );
    await _orderRepository.deleteOrderLine(orderLine);
    getLines();
    await _orderRepository.updateOrders( widget.mesa.id);
    setState(() {
      _editedProduct = {};
    });
  }

  // Remove map dependency and use OrderLine directly
  void onAddProductUnitFromList(Map<String, dynamic> addUnit) async {
    OrderLine orderLine = OrderLine.fromJson(addUnit);
    await _orderRepository.updateOrderLineQuantity(
      orderLine,
      addUnit["quantity"] + 1,
    );
    await _orderRepository.updateOrders( widget.mesa.id);
    getLines();
  }

  void onRemoveProductUnitFromList(Map<String, dynamic> addUnit) async {
    OrderLine orderLine = OrderLine.fromJson(addUnit);
    if (addUnit["quantity"] > 1) {
      await _orderRepository.updateOrderLineQuantity(
        orderLine,
        addUnit["quantity"] - 1,
      );
    } else {
      await _orderRepository.deleteOrderLine(orderLine);
      setState(() {
        _editedProduct = {};
      });
    }

    await _orderRepository.updateOrders(widget.mesa.id);
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
    _orderRepository.updateOrders(widget.mesa.id);
    final List<Order> result = await showDialog(
      context: context,
      builder: (context) => Checkout(mesaID: widget.mesa.id),
    );
    getLines();
    _orderRepository.updateOrders(widget.mesa.id);
    if (!mounted) return;
    if (result.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  void onSplitTable() async {
    await _orderRepository.updateOrders(widget.mesa.id);
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => SplitTable(mesa: widget.mesa),
    );
    getLines();
    await _orderRepository.updateOrders(widget.mesa.id);
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
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
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
    if (result && context.mounted) {
      await _orderRepository.deleteOrderLinesBatch(orderLines);
      await _orderRepository.updateOrders(widget.mesa.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  // *** Print Related ***
  Future onPrintReceive() async {
    await printReceive(database, orderLines, widget.mesa.number);
    RestTable mesa = widget.mesa.copyWithCompanion(
      RestTablesCompanion(state: drift.Value(2)),
    );

    await database.update(database.restTables).replace(mesa);
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
