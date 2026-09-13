import 'package:flutter_proyect/data/services/settings.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Config.init();
  });

  group('welcomeText', () {
    test('returns null when not set', () {
      expect(Config.welcomeText, isNull);
    });

    test('roundtrip set/get welcomeText', () async {
      await Config.setWelcomeText('Hola bienvenido');
      expect(Config.welcomeText, 'Hola bienvenido');
    });

    test('overwrites previous value', () async {
      await Config.setWelcomeText('First');
      await Config.setWelcomeText('Second');
      expect(Config.welcomeText, 'Second');
    });
  });

  group('goodbyeText', () {
    test('returns null when not set', () {
      expect(Config.goodbyeText, isNull);
    });

    test('roundtrip set/get goodbyeText', () async {
      await Config.setGoodbyeText('Adios');
      expect(Config.goodbyeText, 'Adios');
    });
  });

  group('selectedPrinter', () {
    test('returns null when not set', () {
      expect(Config.selectedPrinter, isNull);
    });

    test('roundtrip set/get printer', () async {
      final printer = Printer(
        address: 'AA:BB:CC:DD:EE:FF',
        name: 'Test Printer',
        connectionType: ConnectionType.BLE,
      );

      await Config.setPrinter(printer);
      final retrieved = Config.selectedPrinter;

      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Test Printer');
      expect(retrieved.address, 'AA:BB:CC:DD:EE:FF');
      expect(retrieved.connectionType, ConnectionType.BLE);
    });
  });
}
