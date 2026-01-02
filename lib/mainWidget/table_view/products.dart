import 'package:flutter/material.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class Products extends StatelessWidget {
  final List<ProductsClassData> productsList;
  final void Function(ProductsClassData) onEditProduct;
  final void Function(ProductsClassData) onTapProduct;
  final void Function() onAddProduct;
  const Products({
    super.key,
    required this.productsList,
    required this.onEditProduct,
    required this.onAddProduct,
    required this.onTapProduct,
  });

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
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                children: [
                  ...productsList.map((index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ProyectStyles.buttonStyles(context),
                        onPressed: () {onTapProduct(index);},
                        onLongPress: () {
                          onEditProduct(index);
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
                      style: ProyectStyles.buttonStyles(context),
                      onPressed: () {
                        onAddProduct();
                      },
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
