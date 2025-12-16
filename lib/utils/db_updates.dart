import 'package:drift/drift.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';

class DbUpdates {
  static Future<void> updatedOrders(int tableID) async {
    List<Order> ordersFromTable =
        await (database.select(database.orders)..where((e) {
              return e.restTable.isValue(tableID) & e.closedAt.isNull();
            }))
            .get();

    for (var order in ordersFromTable) {
      final List<OrderLine> orderLines = await (database.select(
        database.orderLines,
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
        totalPriceWithoutTaxes = double.parse(totalPriceWithoutTaxes.toStringAsFixed(2));

        final List<Payment> paymentsList = await (database.select(
          database.payments,
        )..where((e) => e.order.isValue(order.id))).get();
        double totalPayed = paymentsList.fold(
          0,
          (prev, e) => prev + e.payedAmount,
        );

        totalPayed >= order.totalPrice
            ? await (database.update(
                database.orders,
              )..where((e) => e.id.isValue(order.id))).write(
                OrdersCompanion(
                  totalPrice: Value(totalPrice),
                  totalTaxes: Value(totalTaxes),
                  totalPriceWithTaxes: Value(totalPriceWithoutTaxes),
                  closedAt: Value(DateTime.now()),
                  payedPrice: Value(totalPayed),
                ),
              )
            : await (database.update(
                database.orders,
              )..where((e) => e.id.isValue(order.id))).write(
                OrdersCompanion(
                  totalPrice: Value(totalPrice),
                  totalTaxes: Value(totalTaxes),
                  totalPriceWithTaxes: Value(totalPriceWithoutTaxes),
                  payedPrice: Value(totalPayed),
                ),
              );
      } else {
        await (database.delete(
          database.orders,
        )..whereSamePrimaryKey(order)).go();
      }
    }

    //**************************************************
  }
}
