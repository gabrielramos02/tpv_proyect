import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.items,
    required this.onSelectProduct,
    required this.mesa,
  });
  final List<Map<String, dynamic>> items;
  final void Function(Map<String, dynamic>) onSelectProduct;
  final String mesa;

  int totalCantidad() {
    return items.fold(0, (sum, item) => sum + item['cantidad'] as int);
  }

  double totalPrecio() {
    return items.fold(
      0,
      (sum, item) => sum + ((item['cantidad']) * item['precio']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 3,
                children: [
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Mesa: $mesa",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 4),
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(2),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                  },
                  border: TableBorder.all(color: Colors.grey, width: 1.0),
                  children: [
                    // Fila del encabezado
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      children: <Widget>[
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Cant.',
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
                              'PVP',
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
                              'Importe',
                              style: Theme.of(
                                context,
                              ).primaryTextTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...items.map((item) {
                      return TableRow(
                        children: <Widget>[
                          TableCell(
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  item['cantidad'].toString(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              onTap: () {
                                onSelectProduct(item);
                              },
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  item['producto'].toString(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              onTap: () {
                                onSelectProduct(item);
                              },
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "${item['precio'].toString()}€",
                                  style: Theme.of(context).textTheme.labelLarge,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              onTap: () {
                                onSelectProduct(item);
                              },
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${(item['cantidad'] as int) * (item['precio'] as int)}€',
                                  style: Theme.of(context).textTheme.labelLarge,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              onTap: () {
                                onSelectProduct(item);
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 3,
                children: [
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cantidad: ${totalCantidad()}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Total: ${totalPrecio()}",
                      style: Theme.of(context).textTheme.labelLarge,
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
