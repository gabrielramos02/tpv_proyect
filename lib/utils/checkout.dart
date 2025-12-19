import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/db_updates.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';
import 'package:function_tree/function_tree.dart';

import '../main.dart';

TextEditingController inputControllerEfectivo = TextEditingController(text: "");
TextEditingController inputControllerVisa = TextEditingController(text: "");
TextEditingController inputControllerOtros = TextEditingController(text: "");

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.mesaID});
  final int mesaID;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController selected = inputControllerEfectivo;
  String selectedName = "Efectivo";
  List<Payment> paymentList = [];
  List<Order> orderList = [];
  double totalPrice = 0;
  double pagado = 0;

  void onSelected(TextEditingController selection, String name) {
    setState(() {
      selection.text = selected.text;
      selected.text = "";
      selected = selection;
      selectedName = name;
    });
  }

  Future<void> getOrders() async {
    final List<Order> ordersFromTable =
        await (database.select(database.orders)..where(
              (e) => e.restTable.isValue(widget.mesaID) & e.closedAt.isNull(),
            ))
            .get();

    final List<Payment> paymentsFromOrder = await (database.select(
      database.payments,
    )..where((e) => e.order.isIn(ordersFromTable.map((e) => e.id)))).get();

    double price = ordersFromTable.fold(0, (prev, e) => prev + e.totalPrice);

    setState(() {
      orderList = ordersFromTable;
      totalPrice = price;
      paymentList = paymentsFromOrder;
    });
    inputControllerEfectivo.text = totalPrice.toString();
  }

  Future<void> getPayed() async {
    final List<Order> ordersFromTable =
        await (database.select(database.orders)..where(
              (e) => e.restTable.isValue(widget.mesaID) & e.closedAt.isNull(),
            ))
            .get();

    double payed = ordersFromTable.fold(0, (prev, e) => prev + e.payedPrice);
    setState(() {
      pagado = payed;
    });
  }

  void onEnter() async {
    if (double.parse(selected.text) > (totalPrice - pagado)) {
      await database
          .into(database.payments)
          .insert(
            PaymentsCompanion.insert(
              paymentMethod: selectedName,
              payedAmount: double.parse(selected.text),
              order: orderList.first.id,
              paymentDateTime: drift.Value(DateTime.now()),
            ),
          );
      await database
          .into(database.payments)
          .insert(
            PaymentsCompanion.insert(
              paymentMethod: "Devolucion",
              payedAmount: totalPrice - double.parse(selected.text) - pagado,
              order: orderList.first.id,
              paymentDateTime: drift.Value(DateTime.now()),
            ),
          );
    } else {
      await database
          .into(database.payments)
          .insert(
            PaymentsCompanion.insert(
              paymentMethod: selectedName,
              payedAmount: double.parse(selected.text),
              order: orderList.first.id,
              paymentDateTime: drift.Value(DateTime.now()),
            ),
          );
    }
    setState(() {
      pagado = pagado += double.parse(selected.text);
    });
    getOrders();
    await DbUpdates.updatedOrders(widget.mesaID);
    setState(() {
      selected.text = "";
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
    getPayed();
  }

  @override
  void dispose() {
    super.dispose();
    selected.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cobrar', textAlign: TextAlign.center),
      content: Container(
        width: MediaQuery.sizeOf(context).width / 1.5,
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: Colors.black),
                      ),
                      margin: EdgeInsets.only(top: 4),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                        },
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            children: <Widget>[
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tipo',
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
                                    'Cantidad',
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
                                    'Hora de Pago',
                                    style: Theme.of(
                                      context,
                                    ).primaryTextTheme.labelLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Primera fila de datos
                          ...paymentList.map((item) {
                            return TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        item.paymentMethod,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
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
                                        "${item.payedAmount.toStringAsFixed(2)} €",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
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
                                        item.paymentDateTime.toString().substring(0,19),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
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
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          "Efectivo",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black),
                        ),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                            controller: inputControllerEfectivo,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.end,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9+*/.-]*$'),
                              ),
                            ],
                            onChanged: (text) {},
                            onTap: () =>
                                onSelected(inputControllerEfectivo, "Efectivo"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          "Visa",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black),
                        ),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                            controller: inputControllerVisa,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.end,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9+*/.-]*$'),
                              ),
                            ],
                            onChanged: (text) {},
                            onTap: () {
                              onSelected(inputControllerVisa, "Visa");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 4),
                        child: Text(
                          "Otros",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black),
                        ),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                            controller: inputControllerOtros,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.end,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9+*/.-]*$'),
                              ),
                            ],
                            onChanged: (text) {},
                            onTap: () {
                              onSelected(inputControllerOtros, "Otros");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 4,
                children: [
                  Column(
                    spacing: 4,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              "Total a cobrar",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(color: Colors.black),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                totalPrice.toString(),
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              "Entregado",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(color: Colors.black),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                pagado.toString(),
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              "Faltan",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(color: Colors.black),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                totalPrice > pagado
                                    ? (totalPrice - pagado).toString()
                                    : "0",
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              "Cambio",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(color: Colors.black),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Text(
                                pagado > totalPrice
                                    ? (pagado - totalPrice).toStringAsFixed(2)
                                    : "0",
                                style: TextStyle(fontSize: 22),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(child: Container()),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "/",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "*",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "7",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "8",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "9",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "4",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "5",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "6",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "1",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "2",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "3",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(child: Container()),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                "0",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                context,
                                                ".",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(4),
                                          child: ElevatedButton(
                                            style: ProyectStyles.buttonStyles(
                                              context,
                                            ),
                                            onPressed: () {
                                              inputControllerEfectivo.text =
                                                  inputControllerEfectivo.text
                                                      .substring(
                                                        0,
                                                        inputControllerEfectivo
                                                                .text
                                                                .length -
                                                            1,
                                                      );
                                            },
                                            child: Text(
                                              "<-",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: _buildButtonKeyboard(
                                          context,
                                          "-",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: _buildButtonKeyboard(
                                          context,
                                          "+",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.all(4),
                                          child: ElevatedButton(
                                            style: ProyectStyles.buttonStyles(
                                              context,
                                            ),
                                            onPressed: () {
                                              final expression = selected.text;
                                              try {
                                                final result = expression
                                                    .interpret()
                                                    .toDouble();
                                                selected.text = result
                                                    .toString();
                                                onEnter();
                                              } catch (e) {
                                                selected.text = double.nan
                                                    .toString();
                                              }
                                            },
                                            child: Text(
                                              "Enter",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                              textAlign: TextAlign.center,
                                            ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final List<Order> ordersFromTable =
                await (database.select(database.orders)..where(
                      (e) =>
                          e.restTable.isValue(widget.mesaID) &
                          e.closedAt.isNull(),
                    ))
                    .get();

            Navigator.of(context).pop(ordersFromTable);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

Widget _buildButtonKeyboard(BuildContext context, String label) {
  return Container(
    margin: EdgeInsets.all(4),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {
        inputControllerEfectivo.text += label;
      },
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
