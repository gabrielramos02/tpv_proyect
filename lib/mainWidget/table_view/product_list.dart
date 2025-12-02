import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.items,
    required this.onSelectProduct,
  });
  final List<Map<String, dynamic>> items;
  final void Function(Map<String, dynamic>) onSelectProduct;

  final String mesa = "20";
  int totalCantidad() {
    return items.fold(0, (sum, item) => sum + item['cantidad'] as int);
  }

  double totalPrecio() {
    return items.fold(
      0,
      (sum, item) =>
          sum + ((item['cantidad']) * item['precio']),
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
                  // 1. Define los anchos de las columnas (opcional pero recomendado)
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(), // Columna 1: se ajusta al contenido más grande
                    1: FlexColumnWidth(
                      2,
                    ), // Columna 2: ocupa el doble de espacio que las FlexColumnWidth(1)
                    2: FlexColumnWidth(
                      1,
                    ), // Columna 3: ocupa el espacio restante
                  },
                  // 2. Define el borde (opcional)
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
                    ...items.map((item) {
                      return TableRow(
                        children: <Widget>[
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
                                  item['cantidad'].toString(),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              onTap: () {
                                onSelectProduct(item);
                              },
                            ),
                          ),
                          // Se calcula el precio total por item (Cantidad * Precio Unitario)
                          TableCell(
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '\$${(item['cantidad'] as int) * (item['precio'] as int)}',
                                  style: Theme.of(context).textTheme.labelLarge,
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
