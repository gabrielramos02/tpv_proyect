import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/data/repositories/payment_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/ui/core/theme/proyect_styles.dart';
import 'package:function_tree/function_tree.dart';
import 'package:provider/provider.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';

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
  AppDatabase get database => context.read<DatabaseService>().database;
  late final OrderRepository _orderRepository = OrderRepository(
    context.read<DatabaseService>().database,
  );
  late final PaymentRepository _paymentRepository = PaymentRepository(
    context.read<DatabaseService>().database,
  );
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
    final List<Order> ordersFromTable = await _orderRepository.getOrders(
      widget.mesaID,
    );

    final List<Payment> paymentsFromOrder = await _paymentRepository
        .getPayments(ordersFromTable.first.id);

    double price = ordersFromTable.fold(0, (prev, e) => prev + e.totalPrice);

    setState(() {
      orderList = ordersFromTable;
      totalPrice = price;
      paymentList = paymentsFromOrder;
    });
    inputControllerEfectivo.text = totalPrice.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      inputControllerEfectivo.selection = TextSelection(
        baseOffset: 0,
        extentOffset: inputControllerEfectivo.text.length,
      );
    });
  }

  Future<void> getPayed() async {
    final List<Order> ordersFromTable = await _orderRepository.getOrders(
      widget.mesaID,
    );

    double payed = ordersFromTable.fold(0, (prev, e) => prev + e.payedPrice);
    setState(() {
      pagado = payed;
    });
  }

  void onEnter() async {
    await _paymentRepository.addPayment(
      orderId: orderList.first.id,
      amount: double.parse(selected.text),
      method: PaymentMethod.values.firstWhere(
        (e) => e.value == selectedName,
        orElse: () => PaymentMethod.cash,
      ),
    );

    if (totalPrice - double.parse(selected.text) - pagado < 0) {
      await _paymentRepository.addPayment(
        orderId: orderList.first.id,
        amount: totalPrice - double.parse(selected.text) - pagado,
        method: PaymentMethod.returnPayment,
      );
    }

    setState(() {
      pagado = pagado += double.parse(selected.text);
    });
    getOrders();
    await _orderRepository.updateOrders(widget.mesaID);
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
                            controller: inputControllerEfectivo,
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
                              onSelected(inputControllerEfectivo, "Efectivo");
                              selected.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: selected.text.length,
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
                            controller: inputControllerVisa,
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
                              onSelected(inputControllerVisa, "Visa");
                              selected.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: selected.text.length,
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
                              selected.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: selected.text.length,
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
                                                selected,
                                                context,
                                                "/",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
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
                                                selected,
                                                context,
                                                "7",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
                                                context,
                                                "8",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
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
                                                selected,
                                                context,
                                                "4",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
                                                context,
                                                "5",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
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
                                                selected,
                                                context,
                                                "1",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
                                                context,
                                                "2",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
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
                                                selected,
                                                context,
                                                "0",
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildButtonKeyboard(
                                                selected,
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
                                              selected.text = selected.text
                                                  .substring(
                                                    0,
                                                    selected.text.length - 1,
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
                                          selected,
                                          context,
                                          "-",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: _buildButtonKeyboard(
                                          selected,
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
            final List<Order> ordersFromTable = await _orderRepository
                .getOrders(widget.mesaID);
            if (!mounted) return;
            if (!context.mounted) return;
            Navigator.of(context).pop(ordersFromTable);
          },
          child: const Text('OK'),
        ),
      ],
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
