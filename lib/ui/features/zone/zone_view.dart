import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/ui/features/config/config_view.dart';
import 'package:flutter_proyect/ui/features/table/table_view.dart';
import 'package:flutter_proyect/ui/features/zone/new_table_form.dart';
import 'package:flutter_proyect/ui/core/theme/proyect_styles.dart';
import 'package:flutter_proyect/ui/features/zone/view_models/zone_view_model.dart';
import 'package:provider/provider.dart';

class ZoneView extends StatefulWidget {
  const ZoneView({super.key});

  @override
  State<ZoneView> createState() => _ZoneViewState();
}

class _ZoneViewState extends State<ZoneView> {
  late final ZoneViewModel _zoneViewModel = ZoneViewModel(
    TableRepository(context.read<DatabaseService>().database),
  );
  List<Color?> stateList = [Colors.blue[100], Colors.yellow[100], Colors.green];
  bool showSnackBar = false;
  @override
  void initState() {
    super.initState();
    _zoneViewModel.loadTables();
  }

  @override
  void dispose() {
    _zoneViewModel.dispose();
    super.dispose();
  }

  Future<void> onAddTable() async {
    final String response = await showDialog(
      context: context,
      builder: (context) => NewTableForm(),
    );
    if (response != "") {
      await _zoneViewModel.addTable(response);
    }
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
    _zoneViewModel.loadTables();
  }

  void onPrintConfig() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigView()),
    );
    _zoneViewModel.loadTables();
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
    return ListenableBuilder(
      listenable: _zoneViewModel,
      builder: (context, child) {
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
                          if (_zoneViewModel.deleteMode == false) {
                            onShowSnackBar();
                            _zoneViewModel.toggleDeleteMode();
                            setState(() {
                              showSnackBar = true;
                            });
                          } else {
                            hideSnackBar();
                            _zoneViewModel.toggleDeleteMode();
                            setState(() {
                              showSnackBar = false;
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
                          if (_zoneViewModel.deleteMode == true) {
                            _zoneViewModel.toggleDeleteMode();
                          }
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
                        onPressed: () => onPrintConfig(),
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
                child: _zoneViewModel.isLoading && _zoneViewModel.tables.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          ..._zoneViewModel.tables.map((index) {
                            return Positioned(
                              top: index.top,
                              left: index.left,
                              child: LongPressDraggable(
                                onDragEnd: (details) {
                                  _zoneViewModel.moveTable(
                                    index,
                                    details.offset.dx,
                                    details.offset.dy,
                                  );
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
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
                                      if (_zoneViewModel.deleteMode) {
                                        hideSnackBar();
                                        _zoneViewModel.deleteTable(index.id);
                                      } else {
                                        onTablePressed(index);
                                      }
                                    },
                                    child: Text(
                                      index.number,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
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
      },
    );
  }
}
