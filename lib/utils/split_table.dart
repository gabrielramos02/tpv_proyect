import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

import '../main.dart';

class SplitTable extends StatefulWidget {
  const SplitTable({super.key, required this.orderLines});
  final List<OrderLine> orderLines;

  @override
  State<SplitTable> createState() => _SplitTableState();
}

class _SplitTableState extends State<SplitTable> {
  List<OrderLine> leftList = [];
  List<OrderLine> rightList = [];

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

  void MoveLeft(OrderLine pressed) {
    print("Move Left");
  }

  void MoveRight(OrderLine pressed) {
    print("Move Right");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      leftList = widget.orderLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
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
                                  color: Theme.of(context).primaryColor,
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
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            item.quantity.toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        onTap: () {
                                          MoveRight(item);
                                        },
                                      ),
                                    ),
                                    TableCell(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            item.productName.toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                          ),
                                        ),
                                        onTap: () => MoveRight(item),
                                      ),
                                    ),
                                    TableCell(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
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
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '${double.parse(((item.quantity) * (item.currentPrice)).toStringAsFixed(2))}€',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        onTap: () => MoveRight(item),
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
                              mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: Colors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
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
                                  color: Theme.of(context).primaryColor,
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
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            item.quantity.toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        onTap: () => MoveLeft(item),
                                      ),
                                    ),
                                    TableCell(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            item.productName.toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                          ),
                                        ),
                                        onTap: () => MoveLeft(item),
                                      ),
                                    ),
                                    TableCell(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "${item.currentPrice.toString()}€",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        onTap: () => MoveLeft(item),
                                      ),
                                    ),
                                    TableCell(
                                      child: InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
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
                              mainAxisAlignment: MainAxisAlignment.end,
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
                            onPressed: () {},
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
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
