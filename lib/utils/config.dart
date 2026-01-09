import 'dart:convert';

import 'package:flutter_proyect/mainWidget/table_view/select_printer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  static BluetoothPrinter? get selectedPrinter {
      print("estamo aqui");
    final String? jsonString = _prefs.getString('selectedPrinter');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return BluetoothPrinter.fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> setPrinter(BluetoothPrinter printer) async {
      print("estamo aqui");
    await _prefs.setString('selectedPrinter', json.encode(printer.toJson()));
  }
}
