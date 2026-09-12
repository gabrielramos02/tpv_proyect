import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/printer/printer_service.dart';
import 'package:flutter_proyect/domain/constants.dart';
import 'package:flutter_proyect/ui/core/widgets/keyboard.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/free_price_form.dart';

class TableViewModel extends ChangeNotifier {
  TableViewModel({
    required this.orderRepository,
    required this.tableRepository,
    required this.productRepository,
    required this.table,
  });

  final OrderRepository orderRepository;
  final TableRepository tableRepository;
  final ProductRepository productRepository;
  final RestTable table;
  late final PrinterService _printerService = PrinterService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<OrderLine> _orderLines = [];
  List<OrderLine> get orderLines => List.unmodifiable(_orderLines);
  List<ProductTypesTableData> _productTypes = [];
  List<ProductTypesTableData> get productTypes =>
      List.unmodifiable(_productTypes);
  List<ProductsClassData> _products = [];
  List<ProductsClassData> get products => List.unmodifiable(_products);
  int _selectedType = allProductTypesId;
  int get selectedType => _selectedType;
  String _priceText = "";
  String get priceText => _priceText;
  final GlobalKey<KeyboardState> _keyboardKey = GlobalKey<KeyboardState>();
  GlobalKey<KeyboardState> get keyboardKey => _keyboardKey;
  OrderLine? _editedProduct;
  OrderLine? get editedProduct => _editedProduct;

  Future<void> initialize() async {
    await getLines();
    await getProductTypes();
    await getProducts();
  }

  Future<void> getLines() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<OrderLine> result = await orderRepository.getLines(table.id);
      _orderLines = result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductTypes() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await productRepository.getProductTypes();
      _productTypes = response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await productRepository.getProducts();
      _products = response;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectType(int type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<void> onEditProductType(
    ProductTypesTableData productType,
    String? newName,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (newName != "" && newName != null) {
        logger.d("Updating product type ${productType.name} to $newName");
        await productRepository.updateProductTypeName(productType.id, newName);
      } else if (newName == "") {
        logger.d("Deleting product type ${productType.name}");
        await productRepository.deleteProductType(productType.id);
      }
      await getProductTypes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onAddProductType(AddTypesFormResponse? response) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (response?.isCancelled == false) {
        await productRepository.addProductType(
          response?.productName ?? "Empty",
          response?.productOrder ?? 0,
          response?.productColor ?? "#FFFFFF",
        );
        await getProductTypes();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onEditProduct(
    EditProductsFormResponse? response,
    ProductsClassData product,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (response?.isDeleted == false) {
        await productRepository.updateProduct(
          id: product.id,
          name: response?.name ?? product.name,
          price: response?.price ?? product.price,
          type: response?.type ?? product.type,
          taxes: response?.taxes ?? product.taxes,
          order: response?.order ?? product.order,
          color: response?.color ?? product.color,
        );
      } else if (response?.isDeleted == true) {
        await productRepository.deleteProduct(product.id);
      }
      await getProducts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onAddProduct(AddProductsFormResponse? response) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (response?.isCancelled == false) {
        await productRepository.addProduct(
          name: response?.name ?? "Empty",
          price: response?.price ?? 0,
          type: response?.type ?? allProductTypesId,
          taxes: response?.taxes ?? 0,
          order: response?.order ?? 0,
          color: response?.color ?? "#FFFFFF",
        );
        await getProducts();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onTapProduct(ProductsClassData producto) async {
    _isLoading = true;
    notifyListeners();
    try {
      double price = double.parse(producto.price.toStringAsFixed(2));
      if (priceText != "") {
        price = double.parse(priceText);
      }
      final List<Order> orderFromTable = await orderRepository.getOrders(
        table.id,
      );
      final bool isNewProduct = orderLines.every((e) {
        return (e.productName == producto.name && e.currentPrice != price) ||
            (e.productName != producto.name);
      });
      final Taxe taxRate = await productRepository.getTaxById(producto.taxes);
      if (orderFromTable.isEmpty && isNewProduct) {
        final Order newOrder = await orderRepository.addNewOrder(
          table.id,
          price,
          taxRate.rate,
        );
        await orderRepository.addNewOrderLine(
          newOrder.id,
          producto.id,
          price,
          taxRate.rate,
          producto.name,
        );
      } else if (isNewProduct) {
        await orderRepository.addNewOrderLine(
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
        await orderRepository.updateOrderLineQuantity(
          product,
          product.quantity + 1,
        );
      }
      keyboardKey.currentState?.onClearInput();
      await orderRepository.updateOrders(table.id);
      await getLines();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onEditProductList(OrderLine product) {
    _editedProduct = product;
    notifyListeners();
  }

  Future<void> onSaveEditProductList(FreePriceResult? result) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (result?.price != "0") {
        if (_editedProduct == null) return;
        await orderRepository.updateOrderLinePrice(
          _editedProduct!,
          double.parse(result!.price),
        );
      }
      await orderRepository.updateOrders(_editedProduct!.order);
      _editedProduct = null;
      await getLines();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onCancelEditProductList() {
    _editedProduct = null;
    notifyListeners();
  }

  Future<void> onRemoveProductFromList(OrderLine removedProduct) async {
    _isLoading = true;
    notifyListeners();
    try {
      final orderLine = orderLines.firstWhere((e) => e.id == removedProduct.id);
      await orderRepository.deleteOrderLine(orderLine);
      await orderRepository.updateOrders(table.id);
      _editedProduct = null;
      await getLines();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onAddProductUnitFromList(OrderLine addUnit) async {
    _isLoading = true;
    notifyListeners();
    try {
      final orderLine = orderLines.firstWhere((e) => e.id == addUnit.id);
      await orderRepository.updateOrderLineQuantity(
        orderLine,
        orderLine.quantity + 1,
      );
      await orderRepository.updateOrders(table.id);
      await getLines();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onRemoveProductUnitFromList(OrderLine addUnit) async {
    _isLoading = true;
    notifyListeners();
    try {
      final orderLine = orderLines.firstWhere((e) => e.id == addUnit.id);
      if (orderLine.quantity > 1) {
        await orderRepository.updateOrderLineQuantity(
          orderLine,
          orderLine.quantity - 1,
        );
      } else {
        await orderRepository.deleteOrderLine(orderLine);
        _editedProduct = null;
      }
      await orderRepository.updateOrders(table.id);
      await getLines();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onChangePriceText(String priceLabel) {
    _priceText = priceLabel;
    notifyListeners();
  }

  Future<void> updateOrders() async {
    await orderRepository.updateOrders(table.id);
  }

  Future<void> postCheckout() async {
    await orderRepository.updateOrders(table.id);
    getLines();
  }

  Future<void> onDeleteTable() async {
    await orderRepository.deleteOrderLinesBatch(orderLines);
    await orderRepository.updateOrders(table.id);
  }

  Future<void> onPrintReceive() async {
    await _printerService.printReceive(
      orderRepository.db,
      orderLines,
      table.number,
    );
    RestTable mesa = table.copyWithCompanion(
      RestTablesCompanion(state: drift.Value(2)),
    );

    await tableRepository.updateTable(mesa);
  }
}
