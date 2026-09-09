import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:drift/drift.dart' as drift;

class OrderRepository {
  const OrderRepository(this._db);

  final AppDatabase _db;

  AppDatabase get db => _db;

  Future<List<OrderLine>> getLines(int mesaId) async {
    final response =
        await (_db.select(_db.orderLines).join([
              drift.innerJoin(
                _db.orders,
                _db.orders.id.equalsExp(_db.orderLines.order),
              ),
            ])..where(
              _db.orders.restTable.equals(mesaId) &
                  _db.orders.closedAt.isNull(),
            ))
            .get();
    final result = response
        .map((row) => row.readTable(_db.orderLines))
        .toList();

    return result;
  }

  Future<List<Order>> getOrders(int mesaId) async {
    final response = await (_db.select(
      _db.orders,
    )..where((e) => e.restTable.equals(mesaId) & e.closedAt.isNull())).get();
    return response;
  }

  Future<Order?> getOrderById(int orderId) async {
    final response = await (_db.select(
      _db.orders,
    )..where((e) => e.id.equals(orderId))).getSingleOrNull();
    return response;
  }

  Future<List<OrderLine>> getOrderLines(int orderId) async {
    final response = await (_db.select(
      _db.orderLines,
    )..where((e) => e.order.equals(orderId))).get();
    return response;
  }

  Future<Order> addNewOrder(int mesaId, double price, double taxRate) async {
    final order = await _db
        .into(_db.orders)
        .insertReturning(
          OrdersCompanion.insert(
            totalPrice: price,
            payedPrice: 0,
            totalTaxes: taxRate * price,
            totalPriceWithTaxes: (1 - taxRate) * price,
            state: 0,
            restTable: mesaId,
          ),
        );
    return order;
  }

  Future<void> updateOrders(int tableID) async {
    logger.i('Updating orders for table ID: $tableID');
    List<Order> ordersFromTable =
        await (_db.select(_db.orders)..where((e) {
              return e.restTable.isValue(tableID) & e.closedAt.isNull();
            }))
            .get();
    if (ordersFromTable.isNotEmpty) {}
    int tableState = 0;

    for (var order in ordersFromTable) {
      final List<OrderLine> orderLines = await (_db.select(
        _db.orderLines,
      )..where((line) => line.order.isValue(order.id))).get();
      if (orderLines.isNotEmpty) {
        double totalPrice = orderLines.fold(
          0,
          (prev, e) => prev + e.totalPrice,
        );

        totalPrice = double.parse(totalPrice.toStringAsFixed(2));
        double totalTaxes = orderLines.fold(0, (prev, e) => prev + e.taxPrice);
        totalTaxes = double.parse(totalTaxes.toStringAsFixed(2));
        double totalPriceWithoutTaxes = totalPrice - totalTaxes;
        totalPriceWithoutTaxes = double.parse(
          totalPriceWithoutTaxes.toStringAsFixed(2),
        );

        final List<Payment> paymentsList = await (_db.select(
          _db.payments,
        )..where((e) => e.order.isValue(order.id))).get();
        double totalPayed = paymentsList.fold(
          0,
          (prev, e) => prev + e.payedAmount,
        );
        totalPayed = double.parse(totalPayed.toStringAsFixed(2));

        if (totalPayed >= totalPrice) {
          await (_db.update(
            _db.orders,
          )..where((e) => e.id.isValue(order.id))).write(
            OrdersCompanion(
              totalPrice: drift.Value(totalPrice),
              totalTaxes: drift.Value(totalTaxes),
              totalPriceWithTaxes: drift.Value(totalPriceWithoutTaxes),
              closedAt: drift.Value(DateTime.now()),
              payedPrice: drift.Value(totalPayed),
            ),
          );
        } else {
          await (_db.update(
            _db.orders,
          )..where((e) => e.id.isValue(order.id))).write(
            OrdersCompanion(
              totalPrice: drift.Value(totalPrice),
              totalTaxes: drift.Value(totalTaxes),
              totalPriceWithTaxes: drift.Value(totalPriceWithoutTaxes),
              payedPrice: drift.Value(totalPayed),
            ),
          );
          tableState = 1;
        }
      } else {
        await (_db.delete(_db.orders)..whereSamePrimaryKey(order)).go();
      }
      await (_db.update(_db.restTables)..where((e) => e.id.isValue(tableID)))
          .write(RestTablesCompanion(state: drift.Value(tableState)));
    }

    //**************************************************
  }

  Future<void> addNewOrderLine(
    int orderId,
    int productId,
    double price,
    double taxRate,
    String productName,
  ) async {
    await _db
        .into(_db.orderLines)
        .insert(
          OrderLinesCompanion.insert(
            order: orderId,
            totalPrice: price,
            taxPrice: taxRate * price,
            quantity: 1,
            productName: productName,
            taxRate: taxRate,
            currentPrice: price,
          ),
        );
  }

  Future<void> updateOrderLineQuantity(
    OrderLine orderLine,
    int newQuantity,
  ) async {
    final newTotalPrice = orderLine.currentPrice * newQuantity;
    final newTaxPrice = orderLine.taxRate * newTotalPrice;

    await (_db.update(
      _db.orderLines,
    )..where((e) => e.id.equals(orderLine.id))).write(
      OrderLinesCompanion(
        quantity: drift.Value(newQuantity),
        totalPrice: drift.Value(newTotalPrice),
        taxPrice: drift.Value(newTaxPrice),
      ),
    );
  }

  Future<void> updateOrderLinePrice(
    OrderLine orderLine,
    double newPrice,
  ) async {
    final newTotalPrice = newPrice * orderLine.quantity;
    final newTaxPrice = orderLine.taxRate * newTotalPrice;

    await (_db.update(
      _db.orderLines,
    )..where((e) => e.id.equals(orderLine.id))).write(
      OrderLinesCompanion(
        currentPrice: drift.Value(newPrice),
        totalPrice: drift.Value(newTotalPrice),
        taxPrice: drift.Value(newTaxPrice),
      ),
    );
  }

  Future<void> deleteOrderLine(OrderLine orderLine) async {
    await (_db.delete(
      _db.orderLines,
    )..where((e) => e.id.equals(orderLine.id))).go();
  }

  Future<void> deleteOrderLinesBatch(List<OrderLine> orderLines) async {
    final ids = orderLines.map((e) => e.id).toList();
    await (_db.delete(_db.orderLines)..where((e) => e.id.isIn(ids))).go();
  }
}
