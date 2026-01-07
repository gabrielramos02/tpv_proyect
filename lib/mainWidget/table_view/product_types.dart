import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class ProductTypes extends StatelessWidget {
  const ProductTypes({
    super.key,
    required this.productTypesList,
    required this.onSelectType,
    required this.onEditType,
    required this.onAddType,
  });
  final List<ProductTypesTableData> productTypesList;
  final void Function(int) onSelectType;
  final void Function(ProductTypesTableData) onEditType;
  final void Function() onAddType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(2),
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
                    onPressed: () {Navigator.pop(context);},
                    child: Text(
                      "Salir",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                children: [
                  ...productTypesList.map((index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ProyectStyles.buttonStyles(context),
                        onPressed: () {
                          onSelectType(index.id);
                        },
                        onLongPress: () {
                          onEditType(index);
                        },
                        child: Text(
                          index.name,
                          style: Theme.of(context).textTheme.titleSmall,
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
                        padding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      onPressed: () {onAddType();},
                      child: Text(
                        "+",
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
    );
  }
}
