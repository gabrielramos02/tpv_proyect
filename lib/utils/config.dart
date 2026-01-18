import 'dart:convert';

import 'package:flutter_proyect/mainWidget/table_view/select_printer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static BluetoothPrinter? get selectedPrinter {
    final String? jsonString = _prefs.getString('selectedPrinter');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return BluetoothPrinter.fromJson(jsonMap);
    }
    return null;
  }

  static String? get welcomeText {
    final String? welcomeText = _prefs.getString("welcome");
    print(welcomeText);
    return welcomeText;
  }
  static String? get goodbyeText {
    final String? text = _prefs.getString("goodbye");
    return text;
  }

  static Future<void> setPrinter(BluetoothPrinter printer) async {
    await _prefs.setString('selectedPrinter', json.encode(printer.toJson()));
  }

  static Future<void> setWelcomeText(String text) async {
    await _prefs.setString("welcome", text);
    print(text);
  }
  static Future<void> setGoodbyeText(String text) async {
    await _prefs.setString("goodbye", text);
    print(text);
  }
}
