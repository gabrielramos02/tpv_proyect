import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/printer/print_ticket.dart';
import 'package:flutter_proyect/domain/constants.dart';
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
  late final _productRepository = ProductRepository(
    context.read<DatabaseService>().database,
  );
  late final _tableRepository = TableRepository(
    context.read<DatabaseService>().database,
  );
  AppDatabase get database => context.read<DatabaseService>().database;
  List<OrderLine> orderLines = [];
  List<ProductTypesTableData> productTypes = [];
  List<ProductsClassData> products = [];
  int _selectedType = allProductTypesId;
  String priceText = "";
  OrderLine? _editedProduct;
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
    final response = await _productRepository.getProductTypes();
    setState(() {
      productTypes = response;
    });
  }

  Future<void> getProducts() async {
    final response = await _productRepository.getProducts();
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
    final String? newName = await showDialog<String>(
      context: context,
      builder: (context) => EditTypesForm(product: productType),
    );
    if (newName != "" && newName != null) {
      logger.d("Updating product type ${productType.name} to $newName");
      await _productRepository.updateProductTypeName(productType.id, newName);
      getProducts();
    } else if (newName == "") {
      logger.d("Deleting product type ${productType.name}");
      await _productRepository.deleteProductType(productType.id);
      getProductTypes();
    }
  }

  void onAddProductType() async {
    final AddTypesFormResponse? result = await showDialog<AddTypesFormResponse>(
      context: context,
      builder: (context) => AddTypesForm(),
    );

    if (result?.isCancelled == false) {
      await _productRepository.addProductType(
        result?.productName ?? "Empty",
        result?.productOrder ?? 0,
        result?.productColor ?? "#FFFFFF",
      );
      getProductTypes();
    }
  }

  // ***************************************************
  // ***PRODUCT RELATED***
  void onEditProduct(ProductsClassData product) async {
    final EditProductsFormResponse? result =
        await showDialog<EditProductsFormResponse>(
          context: context,
          builder: (context) => EditProductsForm(product: product),
        );

    if (result?.isDeleted == false) {
      await _productRepository.updateProduct(
        id: product.id,
        name: result?.name ?? product.name,
        price: result?.price ?? product.price,
        type: result?.type ?? product.type,
        taxes: result?.taxes ?? product.taxes,
        order: result?.order ?? product.order,
        color: result?.color ?? product.color,
      );
      getProducts();
    } else if (result?.isDeleted == true) {
      await _productRepository.deleteProduct(product.id);
      getProducts();
    }
  }

  void onAddProduct() async {
    final AddProductsFormResponse? result =
        await showDialog<AddProductsFormResponse>(
          context: context,
          builder: (context) => AddProductsForm(selectedFamily: _selectedType),
        );

    if (result?.isCancelled == false) {
      await _productRepository.addProduct(
        name: result?.name ?? "Empty",
        price: result?.price ?? 0.0,
        type: result?.type ?? 0,
        taxes: result?.taxes ?? 0,
        order: result?.order ?? 0,
        color: result?.color ?? "#FFFFFF",
      );
      getProducts();
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
    final bool isNewProduct = orderLines.every((e) {
      return (e.productName == producto.name && e.currentPrice != price) ||
          (e.productName != producto.name);
    });
    final Taxe taxRate = await _productRepository.getTaxById(producto.taxes);
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
  void onEditProductList(OrderLine product) {
    setState(() {
      _editedProduct = product;
    });
  }

  void onSaveEditProductList() async {
    final FreePriceResult? result = await showDialog<FreePriceResult>(
      context: context,
      builder: (context) => FreePriceForm(),
    );

    if (result?.price != "0") {
      if (_editedProduct == null) return;
      await _orderRepository.updateOrderLinePrice(
        _editedProduct!,
        double.parse(result!.price),
      );
    }
    await _orderRepository.updateOrders(_editedProduct!.order);
    getLines();
  }

  void onCancelEditProductList() {
    setState(() {
      _editedProduct = null;
    });
  }

  void onRemoveProductFromList(OrderLine removedProduct) async {
    final orderLine = orderLines.firstWhere((e) => e.id == removedProduct.id);

    await _orderRepository.deleteOrderLine(orderLine);
    await _orderRepository.updateOrders(widget.mesa.id);
    getLines();
    setState(() {
      _editedProduct = null;
    });
  }

  void onAddProductUnitFromList(OrderLine addUnit) async {
    final orderLine = orderLines.firstWhere((e) => e.id == addUnit.id);
    await _orderRepository.updateOrderLineQuantity(
      orderLine,
      orderLine.quantity + 1,
    );
    await _orderRepository.updateOrders(widget.mesa.id);
    await getLines();
  }

  void onRemoveProductUnitFromList(OrderLine addUnit) async {
    final orderLine = orderLines.firstWhere((e) => e.id == addUnit.id);
    if (orderLine.quantity > 1) {
      await _orderRepository.updateOrderLineQuantity(
        orderLine,
        orderLine.quantity - 1,
      );
    } else {
      await _orderRepository.deleteOrderLine(orderLine);
      setState(() {
        _editedProduct = null;
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
    await _orderRepository.updateOrders(widget.mesa.id);

    if (!mounted) return;
    final List<Order>? result = await showDialog<List<Order>>(
      context: context,
      builder: (context) => Checkout(mesaID: widget.mesa.id),
    );
    if (!mounted) return;
    if (result?.isEmpty ?? false) {
      Navigator.of(context).pop();
    }
    getLines();
    _orderRepository.updateOrders(widget.mesa.id);
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

    await _tableRepository.updateTable(mesa);
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
                  if (_editedProduct == null) {
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
                          visible: _selectedType != allProductTypesId,
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
