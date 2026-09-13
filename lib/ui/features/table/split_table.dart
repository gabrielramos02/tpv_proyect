import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/ui/core/theme/proyect_styles.dart';
import 'package:flutter_proyect/ui/features/table/table_view.dart';
import 'package:flutter_proyect/ui/features/table/view_models/split_table_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';

class SplitTable extends StatefulWidget {
  const SplitTable({super.key, required this.mesa});
  final RestTable mesa;

  @override
  State<SplitTable> createState() => _SplitTableState();
}

class _SplitTableState extends State<SplitTable> {
  late final SplitTableModel _splitTableModel = SplitTableModel(
    orderRepository: OrderRepository(context.read<DatabaseService>().database),
    tableRepository: TableRepository(context.read<DatabaseService>().database),
    tableID: widget.mesa.id,
  );
  @override
  void initState() {
    super.initState();
    _splitTableModel.getLeftLines();
    _splitTableModel.getRightLines();
  }

  void onShowSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Debe cobrar todos los productos para volver a la mesa',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void onCheckout() async {
    RestTable checkoutTable = await _splitTableModel.preCheckout();
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => TableView(table: checkoutTable),
    );
    await _splitTableModel.postCheckout();
    if (!mounted) return;
    if (_splitTableModel.leftList.isEmpty &&
        _splitTableModel.rightList.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _splitTableModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _splitTableModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            title: Text('Separar Mesa', textAlign: TextAlign.center),
            content:
                (_splitTableModel.isLoading)
                ? SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    height: 400,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(color: Colors.black),
                                  ),
                                  child: LayoutBuilder(
                                    builder: ((context, constraints) {
                                      return SingleChildScrollView(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Table(
                                                columnWidths:
                                                    const <
                                                      int,
                                                      TableColumnWidth
                                                    >{
                                                      0: IntrinsicColumnWidth(),
                                                      1: FlexColumnWidth(2),
                                                      2: IntrinsicColumnWidth(),
                                                      3: IntrinsicColumnWidth(),
                                                    },
                                                border: TableBorder.all(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                children: [
                                                  // Fila del encabezado
                                                  TableRow(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                                    children: <Widget>[
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Cant.',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Producto',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'PVP',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Importe',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ..._splitTableModel.leftList.map((
                                                    item,
                                                  ) {
                                                    return TableRow(
                                                      children: <Widget>[
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                item.quantity
                                                                    .toString(),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              _splitTableModel
                                                                  .onMoveRight(
                                                                    item,
                                                                  );
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                item.productName
                                                                    .toString(),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _splitTableModel
                                                                    .onMoveRight(
                                                                      item,
                                                                    ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                "${item.currentPrice.toString()}€",
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                            onTap: () {},
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                '${double.parse(((item.quantity) * (item.currentPrice)).toStringAsFixed(2))}€',
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _splitTableModel
                                                                    .onMoveRight(
                                                                      item,
                                                                    ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ],
                                              ),
                                              Container(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  spacing: 3,
                                                  children: [
                                                    Container(
                                                      color: Colors.white70,
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Text(
                                                        "Total: ${_splitTableModel.totalPrecioLeft.toStringAsFixed(2)}",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.labelLarge,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(color: Colors.black),
                                  ),
                                  child: LayoutBuilder(
                                    builder: ((context, constraints) {
                                      return SingleChildScrollView(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Table(
                                                columnWidths:
                                                    const <
                                                      int,
                                                      TableColumnWidth
                                                    >{
                                                      0: IntrinsicColumnWidth(),
                                                      1: FlexColumnWidth(2),
                                                      2: IntrinsicColumnWidth(),
                                                      3: IntrinsicColumnWidth(),
                                                    },
                                                border: TableBorder.all(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                children: [
                                                  // Fila del encabezado
                                                  TableRow(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                                    children: <Widget>[
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Cant.',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Producto',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'PVP',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Text(
                                                            'Importe',
                                                            style: Theme.of(context)
                                                                .primaryTextTheme
                                                                .labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ..._splitTableModel.rightList.map((
                                                    item,
                                                  ) {
                                                    return TableRow(
                                                      children: <Widget>[
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                item.quantity
                                                                    .toString(),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _splitTableModel
                                                                    .onMoveLeft(
                                                                      item,
                                                                    ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                item.productName
                                                                    .toString(),
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _splitTableModel
                                                                    .onMoveLeft(
                                                                      item,
                                                                    ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                "${item.currentPrice.toString()}€",
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _splitTableModel
                                                                    .onMoveLeft(
                                                                      item,
                                                                    ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                '${double.parse(((item.quantity) * (item.currentPrice)).toStringAsFixed(2))}€',
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.labelLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
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

                                              Container(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  spacing: 3,
                                                  children: [
                                                    Container(
                                                      color: Colors.white70,
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Text(
                                                        "Total: ${_splitTableModel.totalPrecioRight.toStringAsFixed(2)}",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.labelLarge,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: ElevatedButton(
                                        style: ProyectStyles.buttonStyles(
                                          context,
                                        ),
                                        onPressed: () {
                                          onCheckout();
                                        },
                                        child: Text(
                                          "Cobrar",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
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
                      ],
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_splitTableModel.rightList.isEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    onShowSnackBar();
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
