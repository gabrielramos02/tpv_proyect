import 'package:flutter/material.dart';
import 'package:flutter_proyect/mainWidget/table_view.dart';

List<Map<String, dynamic>> tableList = [
  {"numero": "3", "top": "10", "left": "20"},
  {"numero": "1", "top": "100", "left": "100"},
  {"numero": "2", "top": "100", "left": "100"},
  {"numero": "4", "top": "100", "left": "100"},
];

class ZoneView extends StatefulWidget {
  const ZoneView({super.key});

  @override
  State<ZoneView> createState() => _ZoneViewState();
}

class _ZoneViewState extends State<ZoneView> {
  void onTablePressed(String mesa) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TableView(mesa: mesa)),
    );
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      alignment: AlignmentGeometry.center,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 23,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Exit",
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
                    top: double.parse(index["top"]),
                    left: double.parse(index["left"]),
                    child: LongPressDraggable(
                      onDragEnd: (details) {
                        setState(() {
                          index["top"] = (details.offset.dy - 56).toString();
                          index["left"] = details.offset.dx.toString();
                        });
                      },
                      onDragStarted: () {},
                      feedback: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColorLight,
                            alignment: AlignmentGeometry.center,
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            index["numero"].toString(),
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
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColorLight,
                            alignment: AlignmentGeometry.center,
                            side: BorderSide(color: Colors.black),
                            padding: EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          onPressed: () =>
                              onTablePressed(index["numero".toString()]),
                          child: Text(
                            index["numero"].toString(),
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
