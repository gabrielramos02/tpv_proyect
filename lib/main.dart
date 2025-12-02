import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proyect/mainWidget/zone_view.dart';
import 'mainWidget/my_home_page.dart';
import 'mainWidget/table_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: "/zoneview",
      routes: {'/zoneview': (context) => const ZoneView(),}
    );
  }
}
