import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/payment_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';

class CheckoutModel extends ChangeNotifier {
  CheckoutModel({
    required this.orderRepository,
    required this.paymentRepository,
    required this.tableId,
  });

  final OrderRepository orderRepository;
  final PaymentRepository paymentRepository;
  final int tableId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController inputControllerCash = TextEditingController(text: "");
  TextEditingController inputControllerVisa = TextEditingController(text: "");
  TextEditingController inputControllerOthers = TextEditingController(text: "");

  late TextEditingController selected = inputControllerCash;
  String selectedName = "Efectivo";

  List<Payment> _paymentList = [];
  List<Payment> get paymentList => List.unmodifiable(_paymentList);
  List<Order> _orderList = [];
  List<Order> get orderList => List.unmodifiable(_orderList);
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  double _paidAmount = 0;
  double get paidAmount => _paidAmount;

  void onSelected(TextEditingController selection, String name) {
    selection.text = selected.text;
    selected.text = "";
    selected = selection;
    selectedName = name;
    notifyListeners();
  }

  Future<void> getOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<Order> ordersFromTable = await orderRepository.getOrders(
        tableId,
      );

      final List<Payment> paymentsFromOrder = await paymentRepository
          .getPayments(ordersFromTable.first.id);

      double price = ordersFromTable.fold(0, (prev, e) => prev + e.totalPrice);

      _orderList = ordersFromTable;
      _totalPrice = price;
      _paymentList = paymentsFromOrder;
      inputControllerCash.text = _totalPrice.toString();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        inputControllerCash.selection = TextSelection(
          baseOffset: 0,
          extentOffset: inputControllerCash.text.length,
        );
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPaid() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<Order> ordersFromTable = await orderRepository.getOrders(
        tableId,
      );

      double payed = ordersFromTable.fold(0, (prev, e) => prev + e.payedPrice);
      _paidAmount = payed;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onEnter() async {
    _isLoading = true;
    notifyListeners();
    try {
      await paymentRepository.addPayment(
        orderId: _orderList.first.id,
        amount: double.parse(selected.text),
        method: PaymentMethod.values.firstWhere(
          (e) => e.value == selectedName,
          orElse: () => PaymentMethod.cash,
        ),
      );

      if (_totalPrice - double.parse(selected.text) - _paidAmount < 0) {
        await paymentRepository.addPayment(
          orderId: _orderList.first.id,
          amount: _totalPrice - double.parse(selected.text) - _paidAmount,
          method: PaymentMethod.returnPayment,
        );
      }

      _paidAmount += double.parse(selected.text);
      getOrders();
      await orderRepository.updateOrders(tableId);
      selected.text = "";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
