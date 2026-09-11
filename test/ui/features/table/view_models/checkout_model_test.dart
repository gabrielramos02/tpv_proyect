import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/payment_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/ui/features/table/view_models/checkout_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late OrderRepository orderRepository;
  late PaymentRepository paymentRepository;
  late CheckoutModel viewModel;
  late int mesaId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orderRepository = OrderRepository(db);
    paymentRepository = PaymentRepository(db);
    final tableRepository = TableRepository(db);
    await tableRepository.addTable(number: '1');
    mesaId = (await tableRepository.getTables()).single.id;
    viewModel = CheckoutModel(
      orderRepository: orderRepository,
      paymentRepository: paymentRepository,
      tableId: mesaId,
    );
  });

  tearDown(() {
    viewModel.dispose();
    db.close();
  });

  Future<int> seedOrderWithLine({double price = 20}) async {
    final order = await orderRepository.addNewOrder(mesaId, 0, 0);
    await db
        .into(db.orderLines)
        .insertReturning(
          OrderLinesCompanion.insert(
            order: order.id,
            productName: 'Beer',
            currentPrice: price,
            totalPrice: price,
            taxRate: 0.21,
            taxPrice: price * 0.21,
            quantity: 1,
          ),
        );
    await orderRepository.updateOrders(mesaId);
    return order.id;
  }

  group('CheckoutModel', () {
    test('getOrders loads the order, total and payments', () async {
      final orderId = await seedOrderWithLine();
      await paymentRepository.addPayment(
        orderId: orderId,
        amount: 8,
        method: PaymentMethod.cash,
      );

      await viewModel.getOrders();

      expect(viewModel.orderList, hasLength(1));
      expect(viewModel.orderList.single.id, orderId);
      expect(viewModel.totalPrice, 20.0);
      expect(viewModel.paymentList, hasLength(1));
      expect(viewModel.paymentList.single.payedAmount, 8.0);
      expect(viewModel.inputControllerCash.text, '20.0');
    });

    test('getOrders flips isLoading around the fetch', () async {
      await seedOrderWithLine();
      expect(viewModel.isLoading, isFalse);

      final future = viewModel.getOrders();
      expect(viewModel.isLoading, isTrue);
      await future;

      expect(viewModel.isLoading, isFalse);
    });

    test('getPaid flips isLoading and sums the paid price', () async {
      final orderId = await seedOrderWithLine();
      await paymentRepository.addPayment(
        orderId: orderId,
        amount: 8,
        method: PaymentMethod.cash,
      );
      await orderRepository.updateOrders(mesaId);

      final future = viewModel.getPaid();
      expect(viewModel.isLoading, isTrue);
      await future;

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.paidAmount, 8.0);
    });

    test(
      'onSelected swaps the active controller and keeps the amount',
      () async {
        viewModel.inputControllerCash.text = '99';

        viewModel.onSelected(viewModel.inputControllerVisa, 'Visa');

        expect(viewModel.selected, same(viewModel.inputControllerVisa));
        expect(viewModel.selectedName, 'Visa');
        expect(viewModel.inputControllerVisa.text, '99');
        expect(viewModel.inputControllerCash.text, '');
      },
    );

    test('onEnter adds a payment and refreshes the paid amount', () async {
      final orderId = await seedOrderWithLine();
      await viewModel.getOrders();
      await viewModel.getPaid();
      viewModel.selected.text = '10';

      await viewModel.onEnter();

      final payments = await paymentRepository.getPayments(orderId);
      expect(payments, hasLength(1));
      expect(payments.single.payedAmount, 10.0);
      expect(payments.single.paymentMethod, 'Efectivo');
      expect(viewModel.paidAmount, 10.0);
      final order = await orderRepository.getOrderById(orderId);
      expect(order!.closedAt, isNull);
    });

    test('onEnter adds a refund when the amount exceeds the total', () async {
      final orderId = await seedOrderWithLine();
      await viewModel.getOrders();
      await viewModel.getPaid();
      viewModel.selected.text = '25';

      await viewModel.onEnter();

      final payments = await paymentRepository.getPayments(orderId);
      expect(payments, hasLength(2));
      expect(payments[0].payedAmount, 25.0);
      expect(payments[1].payedAmount, -5.0);
      expect(payments[1].paymentMethod, 'Devolución');
      expect(viewModel.paidAmount, 25.0);
      final order = await orderRepository.getOrderById(orderId);
      expect(order!.closedAt, isNotNull);
    });
  });
}
