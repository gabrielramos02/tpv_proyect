import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/utils/checkout.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';
import 'package:function_tree/function_tree.dart';

TextEditingController inputController = TextEditingController(text: "");

class Keyboard extends StatefulWidget {
  const Keyboard({super.key});

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  void onCheckout() {
    final result = showDialog(
      context: context,
      builder: (context) => Checkout(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black)),
        child: Column(
          children: [
            Container(
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
                            onChanged: (text) {
                              print(text);
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
                                  margin: EdgeInsets.all(4),
                                  child: ElevatedButton(
                                    style: ProyectStyles.buttonStyles(context),
                                    onPressed: () {onCheckout();},
                                    child: Text(
                                      "Cobrar",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
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
                                child: _buildButtonText(context, "Factura"),
                              ),
                              Expanded(
                                child: _buildButtonText(context, "Borrar Mesa"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Container()),
                              Expanded(child: _buildButtonText(context, "2")),
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
                                child: _buildButtonKeyboard(context, "/"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "*"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "7"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "8"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "9"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "4"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "5"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "6"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonKeyboard(context, "1"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "2"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "3"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildButtonText(
                                  context,
                                  "Separar Mesa",
                                ),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "0"),
                              ),
                              Expanded(
                                child: _buildButtonKeyboard(context, "."),
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
                            margin: EdgeInsets.all(4),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                inputController.text = inputController.text
                                    .substring(
                                      0,
                                      inputController.text.length - 1,
                                    );
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
                          child: _buildButtonKeyboard(context, "-"),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildButtonKeyboard(context, "+"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(4),
                            child: ElevatedButton(
                              style: ProyectStyles.buttonStyles(context),
                              onPressed: () {
                                final expression = inputController.text;
                                try {
                                  final result = expression
                                      .interpret()
                                      .toDouble();
                                  inputController.text = result.toString();
                                } catch (e) {
                                  inputController.text = double.nan.toString();
                                }
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

Widget _buildButtonKeyboard(BuildContext context, String label) {
  return Container(
    margin: EdgeInsets.all(4),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {
        inputController.text += label;
        print(inputController.text);
      },
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

Widget _buildButtonText(BuildContext context, String label) {
  return Container(
    margin: EdgeInsets.all(4),
    child: ElevatedButton(
      style: ProyectStyles.buttonStyles(context),
      onPressed: () {},
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
