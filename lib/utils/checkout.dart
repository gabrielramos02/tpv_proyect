import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';
import 'package:function_tree/function_tree.dart';

TextEditingController inputControllerEfectivo = TextEditingController(text: "");
TextEditingController inputControllerVisa = TextEditingController(text: "");
TextEditingController inputControllerOtros = TextEditingController(text: "");
List movementList = [];

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.precio});
  final String precio;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Map<String, dynamic> response = {};
  TextEditingController selected = inputControllerEfectivo;
  void onSelected(TextEditingController selection) {
    setState(() {
        selection.text = selected.text;
        selected.text = "";
      selected = selection;
    });
  }

  @override
  void initState() {
    super.initState();
    inputControllerEfectivo.text = widget.precio;
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
                                    'Precio',
                                    style: Theme.of(
                                      context,
                                    ).primaryTextTheme.labelLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Primera fila de datos
                          // Filas de datos (generadas dinámicamente)
                          ...movementList.map((item) {
                            return TableRow(
                              children: <Widget>[
                                TableCell(
                                  child: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        item['producto'].toString(),
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
                                        item['cantidad'].toString(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                // Se calcula el precio total por item (Cantidad * Precio Unitario)
                                TableCell(
                                  child: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        '\$${(item['cantidad'] as int) * (item['precio'] as int)}',
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
                            onChanged: (text) {
                              print(text);
                            },
                            onTap: () => onSelected(inputControllerEfectivo),
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
                            onChanged: (text) {
                              print(text);
                            },
                            onTap: () {
                              onSelected(inputControllerVisa);
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
                            onChanged: (text) {
                              print(text);
                            },
                            onTap: () {
                              onSelected(inputControllerOtros);
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
                                "10.00",
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
                                "10.00",
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
                                "10.00",
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
                                "10.00",
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
                                              final expression =
                                                  selected.text;
                                              try {
                                                final result = expression
                                                    .interpret()
                                                    .toDouble();
                                                selected.text =
                                                    result.toString();
                                              } catch (e) {
                                                selected.text =
                                                    double.nan.toString();
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(response);
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
        print(inputControllerEfectivo.text);
      },
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}
