import 'package:flutter/material.dart';

class Products extends StatelessWidget {
    final List<Map<String, dynamic>> productsList;
  final void Function(Map<String, dynamic>) onEditType;
  final void Function() onAddProduct;
  const Products({super.key,required this.productsList,required this.onEditType,required this.onAddProduct});

  @override

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
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 8,
                children: [
                  ...productsList.map((index) {
                    return Container(
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
                        onPressed: () {},
                        onLongPress: (){
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
                        onPressed: () {onAddProduct();},
                        child: Text(
                        "+",
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


