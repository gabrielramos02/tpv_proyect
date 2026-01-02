import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';
import 'package:flutter_proyect/mainWidget/table_view.dart';
import 'package:flutter_proyect/utils/new_table_form.dart';
import 'package:flutter_proyect/utils/proyect_styles.dart';

class ZoneView extends StatefulWidget {
  const ZoneView({super.key});

  @override
  State<ZoneView> createState() => _ZoneViewState();
}

class _ZoneViewState extends State<ZoneView> {
  List<Color?> stateList = [Colors.blue[100], Colors.yellow[100], Colors.green];
  List<RestTable> tableList = [];
  bool deleteTable = false;
  bool showSnackBar = false;
  @override
  void initState() {
    super.initState();
    getTables();
  }

  Future<void> getTables() async {
    final result = await database.select(database.restTables).get();
    setState(() {
      tableList = result;
    });
  }

  Future<void> onDragEnd(RestTable table) async {
    await database.update(database.restTables).replace(table);
    final result = await database.select(database.restTables).get();
    setState(() {
      tableList = result;
    });
  }

  Future<void> onAddTable() async {
    final String response = await showDialog(
      context: context,
      builder: (context) => NewTableForm(),
    );
    if (response != "") {
      await database
          .into(database.restTables)
          .insert(
            RestTablesCompanion.insert(
              number: response,
              top: 10,
              left: 20,
              state: 0,
            ),
          );
    }
    getTables();
  }

  Future<void> onDeleteTable(RestTable table) async {
    (database.delete(
      database.restTables,
    )..where((e) => e.id.isValue(table.id))).go();
    getTables();
    setState(() {
      deleteTable = !deleteTable;
    });
  }

  Future<void> onExit() async {
    final result =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Estas seguro que deseas salir?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Si',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (result && context.mounted) {
      SystemNavigator.pop();
    }
  }

  void onTablePressed(RestTable mesa) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TableView(mesa: mesa)),
    );
    getTables();
  }

  void onShowSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Toca una mesa para eliminarla',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      duration: Duration(seconds: 9999),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {
                      if (!deleteTable) {
                        onShowSnackBar();
                        setState(() {
                          showSnackBar = true;
                          deleteTable = true;
                        });
                      } else {
                        hideSnackBar();
                        setState(() {
                          showSnackBar = false;
                          deleteTable = false;
                        });
                      }
                    },
                    child: Text(
                      "Eliminar Mesa",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () async {
                      hideSnackBar();
                      setState(() {
                        deleteTable = false;
                      });
                      await onAddTable();
                    },
                    child: Text(
                      "Agregar Mesa",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {},
                    child: Text(
                      "Config",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () {},
                    child: Text(
                      "Caja",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ProyectStyles.buttonStyles(context),
                    onPressed: () async {
                      await onExit();
                    },
                    child: Text(
                      "Salir",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ...tableList.map((index) {
                  return Positioned(
                    top: index.top,
                    left: index.left,
                    child: LongPressDraggable(
                      onDragEnd: (details) {
                        final newPositionTable = index.copyWith(
                          top: (details.offset.dy - 56),
                          left: details.offset.dx,
                        );
                        onDragEnd(newPositionTable);
                      },
                      onDragStarted: () {},
                      feedback: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stateList[index.state],
                            alignment: AlignmentGeometry.center,
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            index.number,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stateList[index.state],
                            alignment: AlignmentGeometry.center,
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          onPressed: () async {
                            if (deleteTable) {
                              hideSnackBar();
                              await onDeleteTable(index);
                            } else {
                              onTablePressed(index);
                            }
                          },
                          child: Text(
                            index.number,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
