import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/mainWidget/table_view.dart';
import 'package:flutter_proyect/utils/checkout.dart';
import 'package:flutter_proyect/utils/db_updates.dart';
import 'package:flutter_proyect/utils/print/print_ticket.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

import '../main.dart';

class SplitTable extends StatefulWidget {
  const SplitTable({super.key, required this.mesa});
  final RestTable mesa;

  @override
  State<SplitTable> createState() => _SplitTableState();
}

class _SplitTableState extends State<SplitTable> {
  List<OrderLine> leftList = [];
  List<OrderLine> rightList = [];
  late Order splitTableOrder;
  late int leftLineOrder;
  double totalPrecioLeft() {
    return leftList.fold(
      0,
      (sum, item) =>
          sum +
          (double.parse(
            ((item.quantity) * (item.currentPrice)).toStringAsFixed(2),
          )),
    );
  }

  double totalPrecioRight() {
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
    Order newSplitTableOrder = await database
        .into(database.orders)
        .insertReturning(
          OrdersCompanion.insert(
            totalPrice: 0,
            payedPrice: 0,
            totalTaxes: 0,
            totalPriceWithTaxes: 0,
            state: 0,
            restTable: 99,
          ),
        );
    print("createOrder,${newSplitTableOrder.id}");
    setState(() {
      splitTableOrder = newSplitTableOrder;
    });
  }

  Future<void> getLeftLines() async {
    final response =
        await (database.select(database.orderLines).join([
              drift.innerJoin(
                database.orders,
                database.orders.id.equalsExp(database.orderLines.order),
              ),
            ])..where(
              database.orders.restTable.equals(widget.mesa.id) &
                  database.orders.closedAt.isNull(),
            ))
            .get();
    final result = response
        .map((row) => row.readTable(database.orderLines))
        .toList();
    setState(() {
      leftList = result;
      if (result.isNotEmpty) {
        leftLineOrder = result[0].order;
      }
    });
  }

  Future<void> getRightLines() async {
    final response = await (database.select(
      database.orderLines,
    )..where((e) => e.order.isValue(splitTableOrder.id))).get();
    setState(() {
      rightList = response;
    });
  }

  void onMoveRight(OrderLine pressed) async {
    //Changes on leftLine
    if (pressed.quantity > 1) {
      await (database.update(
        database.orderLines,
      )..whereSamePrimaryKey(pressed)).write(
        pressed.copyWith(
          quantity: pressed.quantity - 1,
          totalPrice: pressed.totalPrice - pressed.currentPrice,
          taxPrice:
              (pressed.totalPrice - pressed.currentPrice) * pressed.taxRate,
        ),
      );
    } else {
      await (database.delete(
        database.orderLines,
      )..whereSamePrimaryKey(pressed)).go();
    }

    //Changes on rightLine
    int indexRightLine = rightList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexRightLine != -1) {
      OrderLine orderOnIndex = rightList[indexRightLine];
      await (database.update(
        database.orderLines,
      )..whereSamePrimaryKey(orderOnIndex)).write(
        orderOnIndex.copyWith(
          quantity: orderOnIndex.quantity + 1,
          totalPrice: orderOnIndex.totalPrice + orderOnIndex.currentPrice,
          taxPrice:
              (orderOnIndex.totalPrice + orderOnIndex.currentPrice) *
              orderOnIndex.taxRate,
        ),
      );
    } else {
      await database
          .into(database.orderLines)
          .insert(
            OrderLinesCompanion.insert(
              productName: pressed.productName,
              currentPrice: pressed.currentPrice,
              totalPrice: pressed.currentPrice,
              taxRate: pressed.taxRate,
              taxPrice: pressed.currentPrice * pressed.taxRate,
              quantity: 1,
              order: splitTableOrder.id,
            ),
          );
    }
    getLeftLines();
    getRightLines();
  }

  void onMoveLeft(OrderLine pressed) async {
    //Changes on rightLine
    if (pressed.quantity > 1) {
      await (database.update(
        database.orderLines,
      )..whereSamePrimaryKey(pressed)).write(
        pressed.copyWith(
          quantity: pressed.quantity - 1,
          totalPrice: pressed.totalPrice - pressed.currentPrice,
          taxPrice:
              (pressed.totalPrice - pressed.currentPrice) * pressed.taxRate,
        ),
      );
    } else {
      await (database.delete(
        database.orderLines,
      )..whereSamePrimaryKey(pressed)).go();
    }

    //Changes on leftLine
    int indexLeftLine = leftList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexLeftLine != -1) {
      OrderLine orderOnIndex = leftList[indexLeftLine];
      await (database.update(
        database.orderLines,
      )..whereSamePrimaryKey(orderOnIndex)).write(
        orderOnIndex.copyWith(
          quantity: orderOnIndex.quantity + 1,
          totalPrice: orderOnIndex.totalPrice + orderOnIndex.currentPrice,
          taxPrice:
              (orderOnIndex.totalPrice + orderOnIndex.currentPrice) *
              orderOnIndex.taxRate,
        ),
      );
    } else {
      await database
          .into(database.orderLines)
          .insert(
            OrderLinesCompanion.insert(
              productName: pressed.productName,
              currentPrice: pressed.currentPrice,
              totalPrice: pressed.currentPrice,
              taxRate: pressed.taxRate,
              taxPrice: pressed.currentPrice * pressed.taxRate,
              quantity: 1,
              order: leftLineOrder,
            ),
          );
    }
    getLeftLines();
    getRightLines();
  }

  void onCheckout() async {
    await DbUpdates.updatedOrders(99);
    await DbUpdates.updatedOrders(widget.mesa.id);
    RestTable mesa = RestTable(id: 99, state: 0, left: 0, top: 0, number: "0");
    final result = await showDialog(
      context: context,
      builder: (context) => TableView(mesa: mesa),
    );
    await DbUpdates.updatedOrders(99);
    await DbUpdates.updatedOrders(widget.mesa.id);
    final Order response = await (database.select(
      database.orders,
    )..whereSamePrimaryKey(splitTableOrder)).getSingle();
    if (response.closedAt != null) {
      await newOrder();
    }
    getRightLines();
    getLeftLines();
    if (leftList.isEmpty && rightList.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  Future onPrintReceive() async {
    if (rightList.isNotEmpty) {
      await printReceive(rightList, widget.mesa.number);
    }
  }

  void onShowSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Debe cobrar todos los productos para volver a la mesa',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    newOrder();
    getLeftLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: Text('Separar Mesa', textAlign: TextAlign.center),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black),
                        ),
                        child: LayoutBuilder(
                          builder: ((context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Table(
                                      columnWidths:
                                          const <int, TableColumnWidth>{
                                            0: IntrinsicColumnWidth(),
                                            1: FlexColumnWidth(2),
                                            2: IntrinsicColumnWidth(),
                                            3: IntrinsicColumnWidth(),
                                          },
                                      border: TableBorder.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      children: [
                                        // Fila del encabezado
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Cant.',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Producto',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'PVP',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Importe',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...leftList.map((item) {
                                          return TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      item.quantity.toString(),
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    onMoveRight(item);
                                                  },
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      item.productName
                                                          .toString(),
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      onMoveRight(item),
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      "${item.currentPrice.toString()}€",
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () {},
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      '${double.parse(((item.quantity) * (item.currentPrice)).toStringAsFixed(2))}€',
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () =>
                                                      onMoveRight(item),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                    Container(
                                      color: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        spacing: 3,
                                        children: [
                                          Container(
                                            color: Colors.white70,
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Total: ${totalPrecioLeft().toStringAsFixed(2)}",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black),
                        ),
                        child: LayoutBuilder(
                          builder: ((context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Table(
                                      columnWidths:
                                          const <int, TableColumnWidth>{
                                            0: IntrinsicColumnWidth(),
                                            1: FlexColumnWidth(2),
                                            2: IntrinsicColumnWidth(),
                                            3: IntrinsicColumnWidth(),
                                          },
                                      border: TableBorder.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      children: [
                                        // Fila del encabezado
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Cant.',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Producto',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'PVP',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Importe',
                                                  style: Theme.of(
                                                    context,
                                                  ).primaryTextTheme.labelLarge,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...rightList.map((item) {
                                          return TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      item.quantity.toString(),
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () => onMoveLeft(item),
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      item.productName
                                                          .toString(),
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                    ),
                                                  ),
                                                  onTap: () => onMoveLeft(item),
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      "${item.currentPrice.toString()}€",
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () => onMoveLeft(item),
                                                ),
                                              ),
                                              TableCell(
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Text(
                                                      '${double.parse(((item.quantity) * (item.currentPrice)).toStringAsFixed(2))}€',
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.labelLarge,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                  onTap: () {},
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),

                                    Container(
                                      color: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        spacing: 3,
                                        children: [
                                          Container(
                                            color: Colors.white70,
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Total: ${totalPrecioRight().toStringAsFixed(2)}",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                onPrintReceive();
                              },
                              child: Text(
                                "Factura",
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                onCheckout();
                              },
                              child: Text(
                                "Cobrar",
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (rightList.isEmpty) {
                Navigator.of(context).pop();
              } else {
                onShowSnackBar();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
