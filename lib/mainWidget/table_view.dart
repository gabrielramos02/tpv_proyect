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
import 'package:flutter_proyect/utils/free_price_form.dart';
//TODO: Checkout, borrar Mesa

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
  @override
  void initState() {
    super.initState();
    getLines();
    getProductTypes();
    getProducts();
  }
  // ***GETTERS***

  Future<void> getLines() async {
    final response = await (database.select(database.orderLines).join([
      drift.innerJoin(
        database.orders,
        database.orders.id.equalsExp(database.orderLines.order),
      ),
    ])..where(database.orders.restTable.equals(widget.mesa.id))).get();
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
    double price = producto.price;
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
      List updatedOrders =
          await (database.update(database.orderLines)..where(
                (e) =>
                    e.order.isValue(orderFromTable.first.id) &
                    e.id.isValue(oldProduct.id),
              ))
              .writeReturning(
                OrderLinesCompanion.custom(
                  quantity:
                      database.orderLines.quantity + const drift.Constant(1),
                  totalPrice:
                      (database.orderLines.totalPrice +
                      database.orderLines.currentPrice),
                ),
              );
      returnedOrder = updatedOrders.first;
    }

    await updateOrders(returnedOrder.order);

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
    updateOrders(oldProduct.order);
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
    updateOrders(orderLine.order);
    setState(() {
      _editedProduct = {};
    });
  }

  void onAddProductUnitFromList(Map<String, dynamic> addUnit) async {
    List<OrderLine> ordersAffected =
        await (database.update(
          database.orderLines,
        )..where((e) => e.id.isValue(addUnit["id"]))).writeReturning(
          OrderLinesCompanion.custom(
            quantity: database.orderLines.quantity + const drift.Constant(1),
          ),
        );
    updateOrders(ordersAffected[0].order);
    getLines();
  }

  void onRemoveProductUnitFromList(Map<String, dynamic> addUnit) async {
    if (addUnit["quantity"] > 1) {
      await (database.update(
        database.orderLines,
      )..where((e) => e.id.isValue(addUnit["id"]))).write(
        OrderLinesCompanion.custom(
          quantity: database.orderLines.quantity - const drift.Constant(1),
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
    updateOrders(addUnit["order"]);
    getLines();
  }

  Future<void> updateOrders(int id) async {
    final List<Order> ordersFromTable =
        await (database.select(database.orders)..where((e) {
              return e.restTable.isValue(widget.mesa.id) & e.closedAt.isNull();
            }))
            .get();
    double totalPrice = ordersFromTable.fold(
      0,
      (prev, e) => prev + e.totalPrice,
    );
    double totalTaxes = ordersFromTable.fold(
      0,
      (prev, e) => prev + e.totalTaxes,
    );
    double totalPriceWithoutTaxes = ordersFromTable.fold(
      0,
      (prev, e) => prev + e.totalPriceWithTaxes,
    );
    await (database.update(
      database.orders,
    )..where((e) => e.id.isValue(id))).write(
      OrdersCompanion(
        totalPrice: drift.Value(totalPrice),
        totalTaxes: drift.Value(totalTaxes),
        totalPriceWithTaxes: drift.Value(totalPriceWithoutTaxes),
      ),
    );
  }

  // *******************************
  // ***Keyboard Related***
  void onChangePriceText(String priceLabel) {
    setState(() {
      priceText = priceLabel;
    });
  }

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
                  Flexible(
                    child: ProductList(
                      items: orderLines,
                      onSelectProduct: onEditProductList,
                      mesa: widget.mesa.number,
                    ),
                  ),
                  Flexible(
                    child: Keyboard(
                      onChangePriceText: onChangePriceText,
                      onEnter: onTapProduct,
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
                        Flexible(
                          child: Products(
                            productsList: products
                                .where((e) => e.type == _selectedType)
                                .toList(),
                            onEditProduct: onEditProduct,
                            onAddProduct: onAddProduct,
                            onTapProduct: onTapProduct,
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
