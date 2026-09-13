import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late OrderRepository repository;
  late int mesaId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repository = OrderRepository(db);

    await db.into(db.restTables).insert(
          RestTablesCompanion.insert(number: '1', top: 0, left: 0, state: 0),
        );
    mesaId = (await db.select(db.restTables).get()).single.id;
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertOrder({
    double totalPrice = 0,
    double payedPrice = 0,
    double totalTaxes = 0,
    double totalPriceWithTaxes = 0,
    DateTime? closedAt,
  }) async {
    return db
        .into(db.orders)
        .insert(
          OrdersCompanion.insert(
            totalPrice: totalPrice,
            payedPrice: payedPrice,
            totalTaxes: totalTaxes,
            totalPriceWithTaxes: totalPriceWithTaxes,
            state: 0,
            restTable: mesaId,
          ).copyWith(
            closedAt:
                closedAt != null ? drift.Value(closedAt) : const drift.Value.absent(),
          ),
        );
  }

  Future<OrderLine> insertLine(
    int orderId,
    String name,
    double price, {
    int quantity = 1,
    double taxRate = 0.21,
  }) async {
    final line = await db
        .into(db.orderLines)
        .insertReturning(
          OrderLinesCompanion.insert(
            order: orderId,
            productName: name,
            currentPrice: price,
            totalPrice: price * quantity,
            taxRate: taxRate,
            taxPrice: taxRate * price * quantity,
            quantity: quantity,
          ),
        );
    return line;
  }

  Future<void> insertPayment(int orderId, double amount) async {
    await db.into(db.payments).insert(
          PaymentsCompanion.insert(
            order: orderId,
            paymentMethod: 'Efectivo',
            payedAmount: amount,
          ),
        );
  }

  Future<RestTable> getTable() async {
    return (await db.select(db.restTables).get()).single;
  }

  group('OrderRepository', () {
    group('getLines', () {
      test('returns lines for open orders of the table', () async {
        final orderId = await insertOrder();
        await insertLine(orderId, 'Beer', 10);

        final lines = await repository.getLines(mesaId);

        expect(lines, hasLength(1));
        expect(lines.single.productName, 'Beer');
      });

      test('excludes lines from closed orders', () async {
        final closedOrderId = await insertOrder(closedAt: DateTime.now());
        await insertLine(closedOrderId, 'Beer', 10);

        final lines = await repository.getLines(mesaId);

        expect(lines, isEmpty);
      });

      test('excludes lines from other tables', () async {
        await db.into(db.restTables).insert(
              RestTablesCompanion.insert(
                number: '2',
                top: 0,
                left: 0,
                state: 0,
              ),
            );
        final otherTable = (await db.select(db.restTables).get()).last;
        final otherOrderId = await db.into(db.orders).insert(
              OrdersCompanion.insert(
                totalPrice: 0,
                payedPrice: 0,
                totalTaxes: 0,
                totalPriceWithTaxes: 0,
                state: 0,
                restTable: otherTable.id,
              ),
            );
        await insertLine(otherOrderId, 'Rum', 8);

        final orderId = await insertOrder();
        await insertLine(orderId, 'Beer', 10);

        final lines = await repository.getLines(mesaId);

        expect(lines, hasLength(1));
        expect(lines.single.productName, 'Beer');
      });
    });

    group('getOrders', () {
      test('returns open orders for the table', () async {
        await insertOrder();
        await insertOrder(closedAt: DateTime.now());

        final orders = await repository.getOrders(mesaId);

        expect(orders, hasLength(1));
      });
    });

    group('getOrderById', () {
      test('returns the order when it exists', () async {
        final orderId = await insertOrder();

        final order = await repository.getOrderById(orderId);

        expect(order, isNotNull);
        expect(order!.id, orderId);
      });

      test('returns null for unknown order', () async {
        final order = await repository.getOrderById(9999);

        expect(order, isNull);
      });
    });

    group('addNewOrder', () {
      test('creates an order linked to the table', () async {
        final order = await repository.addNewOrder(mesaId, 20, 0.21);

        expect(order.restTable, mesaId);
        expect(order.totalPrice, 20.0);
      });
    });

    group('addNewOrderLine', () {
      test('creates a line linked to the order', () async {
        final orderId = await insertOrder();

        await repository.addNewOrderLine(orderId, 1, 10, 0.21, 'Beer');

        final lines = await repository.getOrderLines(orderId);
        expect(lines, hasLength(1));
        expect(lines.single.productName, 'Beer');
        expect(lines.single.currentPrice, 10.0);
      });
    });

    group('updateOrderLineQuantity', () {
      test('updates quantity and recalculates totals', () async {
        final orderId = await insertOrder();
        final line = await insertLine(orderId, 'Beer', 10, quantity: 1);

        await repository.updateOrderLineQuantity(line, 3);

        final updated = await repository.getOrderLines(orderId);
        expect(updated.single.quantity, 3);
        expect(updated.single.totalPrice, 30.0);
        expect(updated.single.taxPrice, closeTo(6.3, 0.001));
      });
    });

    group('updateOrderLinePrice', () {
      test('updates price and recalculates totals', () async {
        final orderId = await insertOrder();
        final line = await insertLine(orderId, 'Beer', 10, quantity: 2);

        await repository.updateOrderLinePrice(line, 12);

        final updated = await repository.getOrderLines(orderId);
        expect(updated.single.currentPrice, 12.0);
        expect(updated.single.totalPrice, 24.0);
      });
    });

    group('deleteOrderLine', () {
      test('removes the line', () async {
        final orderId = await insertOrder();
        final line = await insertLine(orderId, 'Beer', 10);

        await repository.deleteOrderLine(line);

        final lines = await repository.getOrderLines(orderId);
        expect(lines, isEmpty);
      });
    });

    group('deleteOrderLinesBatch', () {
      test('removes multiple lines', () async {
        final orderId = await insertOrder();
        final line1 = await insertLine(orderId, 'Beer', 10);
        final line2 = await insertLine(orderId, 'Wine', 5);

        await repository.deleteOrderLinesBatch([line1, line2]);

        final lines = await repository.getOrderLines(orderId);
        expect(lines, isEmpty);
      });
    });

    group('updateOrders', () {
      test('keeps order open and sets table state to 1 when paid < total', () async {
        final orderId = await insertOrder();
        await insertLine(orderId, 'Beer', 10);
        await insertLine(orderId, 'Wine', 5);

        await repository.updateOrders(mesaId);

        final order = await repository.getOrderById(orderId);
        expect(order!.closedAt, isNull);
        expect(order.totalPrice, 15.0);

        final table = await getTable();
        expect(table.state, 1);
      });

      test('closes order and sets table state to 0 when paid >= total', () async {
        final orderId = await insertOrder();
        await insertLine(orderId, 'Beer', 10);
        await insertPayment(orderId, 10);

        await repository.updateOrders(mesaId);

        final order = await repository.getOrderById(orderId);
        expect(order!.closedAt, isNotNull);
        expect(order.payedPrice, 10.0);

        final table = await getTable();
        expect(table.state, 0);
      });

      test('closes order when paid exceeds total', () async {
        final orderId = await insertOrder();
        await insertLine(orderId, 'Beer', 10);
        await insertPayment(orderId, 15);

        await repository.updateOrders(mesaId);

        final order = await repository.getOrderById(orderId);
        expect(order!.closedAt, isNotNull);
        expect(order.payedPrice, 15.0);
      });

      test('deletes empty open orders', () async {
        await insertOrder();

        await repository.updateOrders(mesaId);

        final orders = await repository.getOrders(mesaId);
        expect(orders, isEmpty);

        final table = await getTable();
        expect(table.state, 0);
      });

      test('does not affect closed orders', () async {
        final closedAt = DateTime(2024, 1, 1);
        final orderId = await insertOrder(closedAt: closedAt);
        await insertLine(orderId, 'Beer', 10);

        await repository.updateOrders(mesaId);

        final order = await repository.getOrderById(orderId);
        expect(order!.closedAt, closedAt);
      });
    });
  });
}
