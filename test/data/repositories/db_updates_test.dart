import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/db_updates.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    app.database = db;
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertTable({int state = 0}) async {
    return db.into(db.restTables).insert(
          RestTablesCompanion.insert(
            top: 100,
            left: 100,
            number: '1',
            state: state,
          ),
        );
  }

  Future<int> insertOrder(int tableId, {DateTime? closedAt}) async {
    return db.into(db.orders).insert(
          OrdersCompanion.insert(
            totalPrice: 0,
            payedPrice: 0,
            totalTaxes: 0,
            totalPriceWithTaxes: 0,
            state: 0,
            restTable: tableId,
            closedAt: Value(closedAt),
          ),
        );
  }

  Future<void> insertOrderLine(
    int orderId, {
    required double totalPrice,
    required double taxPrice,
  }) async {
    await db.into(db.orderLines).insert(
          OrderLinesCompanion.insert(
            productName: 'Test Product',
            currentPrice: 50,
            totalPrice: totalPrice,
            taxRate: 0.2,
            taxPrice: taxPrice,
            quantity: 1,
            order: orderId,
          ),
        );
  }

  Future<void> insertPayment(int orderId, {required double payedAmount}) async {
    await db.into(db.payments).insert(
          PaymentsCompanion.insert(
            paymentMethod: 'cash',
            payedAmount: payedAmount,
            order: orderId,
          ),
        );
  }

  group('DbUpdates.updatedOrders', () {
    test('fully paid order sets closedAt and tableState 0', () async {
      final tableId = await insertTable();
      final orderId = await insertOrder(tableId);
      await insertOrderLine(orderId, totalPrice: 100, taxPrice: 20);
      await insertPayment(orderId, payedAmount: 100);

      await DbUpdates.updatedOrders(tableId);

      final updatedOrder = await (db.select(db.orders)
            ..where((e) => e.id.isValue(orderId)))
          .getSingle();

      expect(updatedOrder.closedAt, isNotNull);
      expect(updatedOrder.totalPrice, 100.0);
      expect(updatedOrder.totalTaxes, 20.0);
      expect(updatedOrder.totalPriceWithTaxes, 80.0);
      expect(updatedOrder.payedPrice, 100.0);

      final table = await (db.select(db.restTables)
            ..where((e) => e.id.isValue(tableId)))
          .getSingle();
      expect(table.state, 0);
    });

    test('partially paid order stays open with tableState 1', () async {
      final tableId = await insertTable();
      final orderId = await insertOrder(tableId);
      await insertOrderLine(orderId, totalPrice: 100, taxPrice: 20);
      await insertPayment(orderId, payedAmount: 50);

      await DbUpdates.updatedOrders(tableId);

      final updatedOrder = await (db.select(db.orders)
            ..where((e) => e.id.isValue(orderId)))
          .getSingle();

      expect(updatedOrder.closedAt, isNull);
      expect(updatedOrder.payedPrice, 50.0);
      expect(updatedOrder.totalPrice, 100.0);

      final table = await (db.select(db.restTables)
            ..where((e) => e.id.isValue(tableId)))
          .getSingle();
      expect(table.state, 1);
    });

    test('order with no lines is deleted', () async {
      final tableId = await insertTable();
      await insertOrder(tableId);

      await DbUpdates.updatedOrders(tableId);

      final remainingOrders = await (db.select(db.orders)
            ..where((e) => e.restTable.isValue(tableId)))
          .get();
      expect(remainingOrders, isEmpty);
    });

    test('totalPriceWithTaxes stores price without VAT (smell)', () async {
      final tableId = await insertTable();
      final orderId = await insertOrder(tableId);
      await insertOrderLine(orderId, totalPrice: 120, taxPrice: 20);
      await insertPayment(orderId, payedAmount: 120);

      await DbUpdates.updatedOrders(tableId);

      final updatedOrder = await (db.select(db.orders)
            ..where((e) => e.id.isValue(orderId)))
          .getSingle();

      expect(updatedOrder.totalPriceWithTaxes, 100.0);
    });
  });
}
