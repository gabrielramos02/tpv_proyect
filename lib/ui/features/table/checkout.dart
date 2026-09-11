import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/payment_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/domain/calculate_from_expression.dart';
import 'package:flutter_proyect/ui/core/theme/proyect_styles.dart';
import 'package:flutter_proyect/ui/features/table/view_models/checkout_model.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.mesaID});
  final int mesaID;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late final _checkoutModel = CheckoutModel(
    orderRepository: OrderRepository(context.read<DatabaseService>().database),
    paymentRepository: PaymentRepository(
      context.read<DatabaseService>().database,
    ),
    tableId: widget.mesaID,
  );

  @override
  void initState() {
    super.initState();
    _checkoutModel.getOrders();
    _checkoutModel.getPaid();
  }

  @override
  void dispose() {
    super.dispose();
    _checkoutModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _checkoutModel,
      builder: (context, child) {
        return AlertDialog(
          title: Text('Cobrar', textAlign: TextAlign.center),
          content: SizedBox(
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
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
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
                              ..._checkoutModel.paymentList.map((item) {
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
                                            item.paymentDateTime
                                                .toString()
                                                .substring(0, 19),
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
                                autofocus: true,
                                showCursor: true,
                                readOnly: true,
                                controller: _checkoutModel.inputControllerCash,
                                keyboardType: TextInputType.none,
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.end,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9+*/.-]*$'),
                                  ),
                                ],
                                onChanged: (text) {},
                                onTap: () {
                                  _checkoutModel.onSelected(
                                    _checkoutModel.inputControllerCash,
                                    "Efectivo",
                                  );
                                  _checkoutModel.selected.selection =
                                      TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _checkoutModel.selected.text.length,
                                      );
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
                                readOnly: true,
                                showCursor: true,
                                controller: _checkoutModel.inputControllerVisa,
                                keyboardType: TextInputType.none,
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.end,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9+*/.-]*$'),
                                  ),
                                ],
                                onChanged: (text) {},
                                onTap: () {
                                  _checkoutModel.onSelected(
                                    _checkoutModel.inputControllerVisa,
                                    "Visa",
                                  );
                                  _checkoutModel.selected.selection =
                                      TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _checkoutModel.selected.text.length,
                                      );
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
                                keyboardType: TextInputType.none,
                                controller:
                                    _checkoutModel.inputControllerOthers,
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.end,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9+*/.-]*$'),
                                  ),
                                ],
                                onChanged: (text) {},
                                onTap: () {
                                  _checkoutModel.onSelected(
                                    _checkoutModel.inputControllerOthers,
                                    "Otros",
                                  );
                                  _checkoutModel.selected.selection =
                                      TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _checkoutModel.selected.text.length,
                                      );
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
                                    _checkoutModel.totalPrice.toString(),
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
                                    _checkoutModel.paidAmount.toString(),
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
                                    _checkoutModel.totalPrice >
                                            _checkoutModel.paidAmount
                                        ? (_checkoutModel.totalPrice -
                                                  _checkoutModel.paidAmount)
                                              .toString()
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
                                    _checkoutModel.paidAmount >
                                            _checkoutModel.totalPrice
                                        ? (_checkoutModel.paidAmount -
                                                  _checkoutModel.totalPrice)
                                              .toStringAsFixed(2)
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
                                                    _checkoutModel.selected,
                                                    context,
                                                    "/",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
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
                                                    _checkoutModel.selected,
                                                    context,
                                                    "7",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
                                                    context,
                                                    "8",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
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
                                                    _checkoutModel.selected,
                                                    context,
                                                    "4",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
                                                    context,
                                                    "5",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
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
                                                    _checkoutModel.selected,
                                                    context,
                                                    "1",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
                                                    context,
                                                    "2",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
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
                                                    _checkoutModel.selected,
                                                    context,
                                                    "0",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _buildButtonKeyboard(
                                                    _checkoutModel.selected,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              child: ElevatedButton(
                                                style:
                                                    ProyectStyles.buttonStyles(
                                                      context,
                                                    ),
                                                onPressed: () {
                                                  _checkoutModel.selected.text =
                                                      _checkoutModel
                                                          .selected
                                                          .text
                                                          .substring(
                                                            0,
                                                            _checkoutModel
                                                                    .selected
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
                                              _checkoutModel.selected,
                                              context,
                                              "-",
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: _buildButtonKeyboard(
                                              _checkoutModel.selected,
                                              context,
                                              "+",
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              margin: EdgeInsets.all(4),
                                              child: ElevatedButton(
                                                style:
                                                    ProyectStyles.buttonStyles(
                                                      context,
                                                    ),
                                                onPressed: () {
                                                  _checkoutModel.selected.text =
                                                      calculate(
                                                        _checkoutModel
                                                            .selected
                                                            .text,
                                                      );
                                                  _checkoutModel.onEnter();
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
                final List<Order> ordersFromTable = await _checkoutModel
                    .orderRepository
                    .getOrders(widget.mesaID);
                if (!mounted) return;
                if (!context.mounted) return;
                Navigator.of(context).pop(ordersFromTable);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildButtonKeyboard(
  TextEditingController controller,
  BuildContext context,
  String label,
) {
  return Container(
    margin: EdgeInsets.all(4),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {
        if (!controller.selection.isCollapsed) {
          controller.clear();
          controller.text += label;
        } else {
          controller.text += label;
        }
      },
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
