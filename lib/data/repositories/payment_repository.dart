import 'package:drift/drift.dart' as drift;
import 'package:flutter_proyect/data/services/database/dbConnection.dart';

enum PaymentMethod {
  cash("Efectivo"),
  card("Visa"),
  others("Otros"),
  returnPayment("Devolución");

  final String value;
  const PaymentMethod(this.value);
}

class PaymentRepository {
  const PaymentRepository(this._db);

  final AppDatabase _db;

  Future<void> addPayment({
    required int orderId,
    required double amount,
    required PaymentMethod method,
  }) async {
    await _db
        .into(_db.payments)
        .insert(
          PaymentsCompanion.insert(
            order: orderId,
            paymentMethod: method.value,
            payedAmount: amount,
            paymentDateTime: drift.Value(DateTime.now())
          ),
        );
  }
}
