import 'dart:convert';

import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/services/printer/printer_service.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    PrinterService printerService = PrinterService();
    if (Config.selectedPrinter == null) return;
    await printerService.connectDevice();
    logger.i("Connected to printer: ${selectedPrinter?.uniqueId}");
  }

  static Printer? get selectedPrinter {
    final String? jsonString = _prefs.getString('selectedPrinter');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return Printer.fromJson(jsonMap);
    }
    return null;
  }

  static String? get welcomeText {
    final String? welcomeText = _prefs.getString("welcome");
    return welcomeText;
  }

  static String? get goodbyeText {
    final String? text = _prefs.getString("goodbye");
    return text;
  }

  static Future<void> setPrinter(Printer printer) async {
    await _prefs.setString('selectedPrinter', json.encode(printer.toJson()));
  }

  static Future<void> setWelcomeText(String text) async {
    await _prefs.setString("welcome", text);
  }

  static Future<void> setGoodbyeText(String text) async {
    await _prefs.setString("goodbye", text);
  }
}
