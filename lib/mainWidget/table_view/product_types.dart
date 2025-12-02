import 'package:flutter/material.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class ProductTypes extends StatelessWidget {
  const ProductTypes({
    super.key,
    required this.productTypesList,
    required this.onSelectType,
    required this.onEditType,
    required this.onAddType,
  });
  final List<Map<String, dynamic>> productTypesList;
  final void Function(String) onSelectType;
  final void Function(Map<String, dynamic>) onEditType;
  final void Function() onAddType;

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
                children: [
                  ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {},
                    child: Text(
                      "Exit",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 8,
                children: [
                  ...productTypesList.map((index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ProyectStyles.buttonStyles(context),
                        onPressed: () {
                          onSelectType(index["nombre"]);
                        },
                        onLongPress: () {
                          onEditType(index);
                        },
                        child: Text(
                          index["nombre"].toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        alignment: AlignmentGeometry.center,
                        side: BorderSide(color: Colors.black),
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      onPressed: () {onAddType();},
                      child: Text(
                        "+",
                        style: Theme.of(context).textTheme.headlineLarge,
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
    );
  }
}
