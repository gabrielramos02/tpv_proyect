import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/payment_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late PaymentRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = PaymentRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertOrder() async {
    return db
        .into(db.orders)
        .insert(
          OrdersCompanion.insert(
            totalPrice: 0,
            payedPrice: 0,
            totalTaxes: 0,
            totalPriceWithTaxes: 0,
            state: 0,
            restTable: 1,
          ),
        );
  }

  Future<List<Payment>> getPayments() => db.select(db.payments).get();

  group('PaymentRepository', () {
    test(
      'addPayment inserts a payment with amount, method and timestamp',
      () async {
        final orderId = await insertOrder();

        await repository.addPayment(
          orderId: orderId,
          amount: 25.5,
          method: PaymentMethod.cash,
        );

        final payments = await getPayments();
        expect(payments, hasLength(1));
        expect(payments.single.order, orderId);
        expect(payments.single.payedAmount, 25.5);
        expect(payments.single.paymentMethod, 'Efectivo');
        expect(payments.single.paymentDateTime, isNotNull);
      },
    );

    test('addPayment stores the value of each payment method', () async {
      final orderId = await insertOrder();
      const expected = <PaymentMethod, String>{
        PaymentMethod.cash: 'Efectivo',
        PaymentMethod.card: 'Visa',
        PaymentMethod.others: 'Otros',
        PaymentMethod.returnPayment: 'Devolución',
      };

      for (final entry in expected.entries) {
        await repository.addPayment(
          orderId: orderId,
          amount: 1.0,
          method: entry.key,
        );

        final payments = await getPayments();
        expect(payments.last.paymentMethod, entry.value);
      }
    });

    test('addPayment allows negative amounts for return payments', () async {
      final orderId = await insertOrder();

      await repository.addPayment(
        orderId: orderId,
        amount: -2.5,
        method: PaymentMethod.returnPayment,
      );

      final payments = await getPayments();
      expect(payments.single.payedAmount, -2.5);
    });

    test('payments are tracked per order', () async {
      final orderId = await insertOrder();
      final otherOrderId = await insertOrder();

      await repository.addPayment(
        orderId: orderId,
        amount: 10,
        method: PaymentMethod.cash,
      );
      await repository.addPayment(
        orderId: otherOrderId,
        amount: 20,
        method: PaymentMethod.card,
      );

      final payments = await getPayments();
      expect(payments, hasLength(2));
      expect(payments.where((p) => p.order == orderId).single.payedAmount, 10);
      expect(
        payments.where((p) => p.order == otherOrderId).single.payedAmount,
        20,
      );
    });
  });
}
