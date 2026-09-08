import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/ui/core/theme/proyect_styles.dart';
import 'package:flutter_proyect/ui/features/table/table_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';

class SplitTable extends StatefulWidget {
  const SplitTable({super.key, required this.mesa});
  final RestTable mesa;

  @override
  State<SplitTable> createState() => _SplitTableState();
}

class _SplitTableState extends State<SplitTable> {
  AppDatabase get database => context.read<DatabaseService>().database;
  OrderRepository get _orderRepository =>
      OrderRepository(context.read<DatabaseService>().database);
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
    Order newSplitTableOrder = await _orderRepository.addNewOrder(
      99,
      0,
      leftList.isNotEmpty ? leftList[0].taxRate : 0,
    );
    setState(() {
      splitTableOrder = newSplitTableOrder;
    });
  }

  Future<void> getLeftLines() async {
    List<OrderLine> result = await _orderRepository.getLines(widget.mesa.id);
    setState(() {
      leftList = result;
      if (result.isNotEmpty) {
        leftLineOrder = result[0].order;
      }
    });
  }

  Future<void> getRightLines() async {
    List<OrderLine> result = await _orderRepository.getOrderLines(
      splitTableOrder.id,
    );
    setState(() {
      rightList = result;
    });
  }

  void onMoveRight(OrderLine pressed) async {
    //Changes on leftLine
    if (pressed.quantity > 1) {
      await _orderRepository.updateOrderLineQuantity(
        pressed,
        pressed.quantity - 1,
      );
    } else {
      await _orderRepository.deleteOrderLine(pressed);
    }

    //Changes on rightLine
    int indexRightLine = rightList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexRightLine != -1) {
      OrderLine orderOnIndex = rightList[indexRightLine];
      await _orderRepository.updateOrderLineQuantity(
        orderOnIndex,
        orderOnIndex.quantity + 1,
      );
    } else {
        await _orderRepository.addNewOrderLine(
            splitTableOrder.id,
            pressed.id,
            pressed.currentPrice,
            pressed.taxRate,
            pressed.productName,
            );
    }
    getLeftLines();
    getRightLines();
  }

  void onMoveLeft(OrderLine pressed) async {
    //Changes on rightLine
    if (pressed.quantity > 1) {
        await _orderRepository.updateOrderLineQuantity(
        pressed,
        pressed.quantity - 1,
        );
    } else {
        await _orderRepository.deleteOrderLine(pressed);
    }
    //Changes on leftLine
    int indexLeftLine = leftList.indexWhere(
      (e) =>
          e.productName == pressed.productName &&
          e.currentPrice == pressed.currentPrice,
    );
    if (indexLeftLine != -1) {
      OrderLine orderOnIndex = leftList[indexLeftLine];
      await _orderRepository.updateOrderLineQuantity(
        orderOnIndex,
        orderOnIndex.quantity + 1,
      );
    } else {
        await _orderRepository.addNewOrderLine(
            leftLineOrder,
            pressed.id,
            pressed.currentPrice,
            pressed.taxRate,
            pressed.productName,
          );
    }
    getLeftLines();
    getRightLines();
  }

  void onCheckout() async {
    await _orderRepository.updateOrders(99);
    await _orderRepository.updateOrders(widget.mesa.id);
    RestTable mesa = RestTable(id: 99, state: 0, left: 0, top: 0, number: "0");
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => TableView(mesa: mesa),
    );
    await _orderRepository.updateOrders(99);
    await _orderRepository.updateOrders(widget.mesa.id);
    final Order response = await (database.select(
      database.orders,
    )..whereSamePrimaryKey(splitTableOrder)).getSingle();
    if (response.closedAt != null) {
      await newOrder();
    }
    getRightLines();
    getLeftLines();
    if (!mounted) return;
    if (leftList.isEmpty && rightList.isEmpty) {
      Navigator.of(context).pop();
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
