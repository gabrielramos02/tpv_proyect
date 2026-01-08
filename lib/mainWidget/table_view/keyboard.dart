import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/calculate_from_expression.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({
    super.key,
    required this.onChangePriceText,
    required this.onEnter,
    required this.onCheckout,
    required this.onDeleteTable,
    required this.onSplitTable,
    required this.onPrintReceive,
  });
  final void Function(String) onChangePriceText;
  final void Function(ProductsClassData) onEnter;
  final void Function() onCheckout;
  final void Function() onDeleteTable;
  final void Function() onSplitTable;
  final Future Function() onPrintReceive;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  TextEditingController inputController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    inputController.text = "";
    inputController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
  }

  void onTextChanged() {
    widget.onChangePriceText(inputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black)),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 3,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            "Precio Libre",
                            style: Theme.of(context).primaryTextTheme.titleMedium,
                          ),
                        ),
                        Container(
                          color: Colors.white70,
                          child: SizedBox(
                            width: 150,
                            child: TextField(
                              controller: inputController,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.end,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9+*/.-]*$'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Container()),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: ElevatedButton(
                                    style: ProyectStyles.buttonStyles(context),
                                    onPressed: () {
                                      widget.onCheckout();
                                    },
                                    child: Text(
                                      "Cobrar",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonText(context, "Cajon"),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: ElevatedButton(
                                    style: ProyectStyles.buttonStyles(context),
                                    onPressed: () {
                                      widget.onPrintReceive();
                                    },
                                    child: Text(
                                      "Factura",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: ElevatedButton(
                                    style: ProyectStyles.buttonStyles(context),
                                    onPressed: () {
                                      widget.onDeleteTable();
                                    },
                                    child: Text(
                                      "Borrar Mesa",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonText(context, "Buscar"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "/",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "*",inputController),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "7",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "8",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "9",inputController),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "4",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "5",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "6",inputController),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "1",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "2",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "3",inputController),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: ElevatedButton(
                                    style: ProyectStyles.buttonStyles(context),
                                    onPressed: () {
                                      widget.onSplitTable();
                                    },
                                    child: Text(
                                      "Separar Mesa",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "0",inputController),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, ".",inputController),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                inputController.text = inputController.text
                                    .substring(
                                      0,
                                      inputController.text.length - 1,
                                    );
                                widget.onChangePriceText(inputController.text);
                              },
                              child: Text(
                                "<-",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildButtonKeyboard(context, "-",inputController),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildButtonKeyboard(context, "+",inputController),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                inputController.text = calculate(
                                  inputController.text,
                                );
                                widget.onEnter(
                                  ProductsClassData(
                                    id: 99,
                                    name: "Varios",
                                    price: double.parse(inputController.text),
                                    color: "",
                                    order: 0,
                                    type: 0,
                                    taxes: 1,
                                  ),
                                );
                                inputController.text = "";
                                widget.onChangePriceText(inputController.text);
                              },
                              child: Text(
                                "Enter",
                                style: Theme.of(context).textTheme.titleMedium,
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
    );
  }
}

Widget _buildButtonKeyboard(
  BuildContext context,
  String label,
  TextEditingController inputController,
) {
  return Container(
    padding: EdgeInsets.all(2),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {
        inputController.text += label;
      },
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    ),
  );
}

Widget _buildButtonText(BuildContext context, String label) {
  return Container(
    padding: EdgeInsets.all(2),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {},
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
