import 'package:flutter/foundation.dart';
import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/domain/constants.dart';

class SplitTableModel extends ChangeNotifier {
  SplitTableModel({
    required this.orderRepository,
    required this.tableRepository,
    required this.tableID,
  });

  final OrderRepository orderRepository;
  final TableRepository tableRepository;
  final int tableID;

  bool isLoading = false;

  late List<OrderLine> leftList;
  late List<OrderLine> rightList;
  Order? splitTableOrder;
  int? leftLineOrderId;

  double get totalPrecioLeft {
    return leftList.fold(
      0,
      (sum, item) =>
          sum +
          (double.parse(
            ((item.quantity) * (item.currentPrice)).toStringAsFixed(2),
          )),
    );
  }

  double get totalPrecioRight {
    return rightList.fold(
      0,
      (sum, item) =>
          sum +
          (double.parse(
            ((item.quantity) * (item.currentPrice)).toStringAsFixed(2),
          )),
    );
  }

  Future<void> newOrder() async {
    Order newSplitTableOrder = await orderRepository.addNewOrder(
      phantomTableId,
      0,
      0,
    );
    splitTableOrder = newSplitTableOrder;
  }

  Future<void> getLeftLines() async {
    isLoading = true;
    notifyListeners();
    try {
      List<OrderLine> result = await orderRepository.getLines(tableID);
      leftList = result;
      if (result.isNotEmpty) {
        leftLineOrderId = result[0].order;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRightLines() async {
    if (splitTableOrder == null) {
      await newOrder();
    }
    isLoading = true;
    notifyListeners();
    try {
      logger.i('Getting right lines for order ID: ${splitTableOrder!.id}');
      List<OrderLine> result = await orderRepository.getOrderLines(
        splitTableOrder!.id,
      );
      rightList = result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onMoveRight(OrderLine pressed) async {
    if (pressed.quantity > 1) {
      await orderRepository.updateOrderLineQuantity(
        pressed,
        pressed.quantity - 1,
      );
    } else {
      await orderRepository.deleteOrderLine(pressed);
    }

    //Changes on rightLine
    int indexRightLine = rightList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexRightLine != -1) {
      OrderLine orderOnIndex = rightList[indexRightLine];
      await orderRepository.updateOrderLineQuantity(
        orderOnIndex,
        orderOnIndex.quantity + 1,
      );
    } else {
      await orderRepository.addNewOrderLine(
        splitTableOrder!.id,
        pressed.id,
        pressed.currentPrice,
        pressed.taxRate,
        pressed.productName,
      );
    }
    getLeftLines();
    getRightLines();
  }

  Future<void> onMoveLeft(OrderLine pressed) async {
    //Changes on rightLine
    if (pressed.quantity > 1) {
      await orderRepository.updateOrderLineQuantity(
        pressed,
        pressed.quantity - 1,
      );
    } else {
      await orderRepository.deleteOrderLine(pressed);
    }
    //Changes on leftLine
    int indexLeftLine = leftList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexLeftLine != -1) {
      OrderLine orderOnIndex = leftList[indexLeftLine];
      await orderRepository.updateOrderLineQuantity(
        orderOnIndex,
        orderOnIndex.quantity + 1,
      );
    } else {
      await orderRepository.addNewOrderLine(
        leftLineOrderId!,
        pressed.id,
        pressed.currentPrice,
        pressed.taxRate,
        pressed.productName,
      );
    }
    getLeftLines();
    getRightLines();
  }

  Future<RestTable> preCheckout() async {
    await orderRepository.updateOrders(phantomTableId);
    await orderRepository.updateOrders(tableID);
    return RestTable(
      id: phantomTableId,
      state: 0,
      left: 0,
      top: 0,
      number: "0",
    );
  }

  Future<void> postCheckout() async {
    await orderRepository.updateOrders(phantomTableId);
    await orderRepository.updateOrders(tableID);
    final originalOrder = await orderRepository.getOrderById(
      splitTableOrder!.id,
    );
    if (originalOrder?.closedAt != null) {
      await newOrder();
    }
    getRightLines();
    getLeftLines();
  }
}
