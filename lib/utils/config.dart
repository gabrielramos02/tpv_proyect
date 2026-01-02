import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get selectedPrinter {
    return _prefs.getString('printer_address') ?? '';
  }

  static Future<void> setPrinterAddress(String address) async {
    await _prefs.setString('printer_address', address);
  }
}
