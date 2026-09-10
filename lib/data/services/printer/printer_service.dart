import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_proyect/core/logger.dart';
import 'package:flutter_proyect/data/repositories/ticket_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/data/services/settings.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterService extends ChangeNotifier {
  PrinterService();
  final printerManager = FlutterThermalPrinter.instance;

  bool _isScanning = false;
  bool _isConnected = false;
  List<Printer> _devices = <Printer>[];
  StreamSubscription<List<Printer>>? _subscription;
  final List<ConnectionType> _connections = <ConnectionType>[
    ConnectionType.BLE,
    ConnectionType.NETWORK,
  ];

  String? _mensajeInicial = Config.welcomeText;
  String? _mensajeDespedida = Config.goodbyeText;
  String _ipAddress = '';
  String _port = '9100';
  Printer? _selectedPrinter;
  ConnectionType? _selectedPrinterType = ConnectionType.BLE;

  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<Printer> get devices => _devices;
  String? get mensajeInicial => _mensajeInicial;
  String? get mensajeDespedida => _mensajeDespedida;
  Printer? get selectedPrinter => _selectedPrinter;
  ConnectionType? get selectedPrinterType => _selectedPrinterType;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> scan() async {
    if (Platform.isAndroid) {
      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }
      if (await Permission.locationWhenInUse.isDenied) {
        await Permission.locationWhenInUse.request();
      }
    }
    logger.i("Scanning for printers with connection types: $_connections");
    _isScanning = true;
    await printerManager.getPrinters(connectionTypes: _connections);
    _subscription = printerManager.devicesStream.listen((List<Printer> event) {
      _devices = event;
      devices.removeWhere(
        ((element) =>
            element.name == null ||
            element.name == '' ||
            element.name!.toLowerCase().contains("print") == false),
      );
      notifyListeners();
    });
    notifyListeners();
  }

  void stopScan() {
    logger.i("Stopping printer scan");
    printerManager.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  void setBLEConfig() {
    printerManager.bleConfig = const BleConfig(
      connectionStabilizationDelay: Duration(seconds: 3),
    );
  }

  // TODO fix set port
  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = Printer(
      name: value,
      address: _ipAddress,
      connectionType: ConnectionType.NETWORK,
      isConnected: false,
    );
    selectDevice(device);
  }

  // TODO fix set ip address
  void setIpAddress(String value) {
    _ipAddress = value;
    var device = Printer(
      name: value,
      address: _ipAddress,
      connectionType: ConnectionType.NETWORK,
    );
    selectDevice(device);
  }

  Future<void> selectDevice(Printer device) async {
    if (_selectedPrinter != null) {
      if ((device.address != _selectedPrinter!.address) ||
          (device.connectionType == ConnectionType.USB &&
              _selectedPrinter!.vendorId != device.vendorId)) {
        await printerManager.disconnect(_selectedPrinter!);
      }
    }
    _selectedPrinter = device;
    notifyListeners();
  }

  Future<void> connectDevice() async {
    stopScan();
    _isConnected = false;
    notifyListeners();
    if (_selectedPrinter == null) return;
    await printerManager.disconnect(_selectedPrinter!);
    switch (_selectedPrinter!.connectionType) {
      case ConnectionType.USB:
        await printerManager.connect(_selectedPrinter!);
        _isConnected = true;
        break;
      case ConnectionType.BLE:
        await printerManager.connect(_selectedPrinter!);
        _isConnected = true;
        break;
      default:
    }
    notifyListeners();
    logger.i("Connected to printer: ${_selectedPrinter?.uniqueId}");
  }

  Future<void> disconnectDevice() async {
    if (_selectedPrinter == null) return;
    await printerManager.disconnect(_selectedPrinter!);
    _isConnected = false;
    notifyListeners();
    logger.i("Disconnected from printer: ${_selectedPrinter?.uniqueId}");
  }

  Future<void> printTestTicket() async {
    logger.i("Preparing test print for printer: ${_selectedPrinter?.uniqueId}");
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(
      'Test Print',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text('Product 1');
    bytes += generator.text('Product 2');
    bytes += generator.feed(2);
    bytes += generator.cut();

    _printEscPos(bytes);
  }

  Future<void> printReceive(
    AppDatabase database,
    List<OrderLine> orderLines,
    String number,
  ) async {
    logger.i('Starting print process for table: $number');
    final ticketRepository = TicketRepository(database);
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(
      'Restaurant',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1,
    );
    bytes += generator.text(
      'SAL I PEBRE',
      styles: PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size3,
        width: PosTextSize.size3,
      ),
    );
    bytes += generator.text(
      _mensajeInicial ?? "",
      styles: PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        align: PosAlign.center,
      ),
    );
    bytes += generator.text('-' * 48);
    bytes += generator.text(
      'Mesa:$number',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );
    //Primera fila
    bytes += generator.row([
      PosColumn(
        text: 'Cant.',
        width: 2,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Articulo',
        width: 7,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'Importe',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);
    // Resto de filas
    double suma = 0;
    for (var orderLine in orderLines) {
      suma += orderLine.totalPrice;
      String linePrice = orderLine.totalPrice.toStringAsFixed(2);
      var priceText = Uint8List.fromList(linePrice.codeUnits + [128]);
      bytes += generator.row([
        PosColumn(
          text: '${orderLine.quantity}x',
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, styles: PosStyles(align: PosAlign.right)),
        PosColumn(
          text: orderLine.productName.toUpperCase(),
          width: 5,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          textEncoded: priceText,
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.emptyLines(2);
    suma = double.parse(suma.toStringAsFixed(2));

    var totalPrice = Uint8List.fromList('TOTAL: $suma'.codeUnits + [128]);
    bytes += generator.textEncoded(
      totalPrice,
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        align: PosAlign.right,
      ),
    );
    bytes += generator.emptyLines(1);
    Ticket ticket = await ticketRepository.addTicket(suma);
    bytes += generator.text(
      'FACTURA SIMPLIFICADA',
      styles: PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        align: PosAlign.left,
      ),
    );

    bytes += generator.row([
      PosColumn(
        text: 'N°${orderLines[0].order.toString().padLeft(8, '0')}',
        width: 5,
        styles: PosStyles(align: PosAlign.left, underline: false),
      ),
      PosColumn(
        text: '${ticket.createdAt}',
        width: 7,
        styles: PosStyles(align: PosAlign.left, underline: false),
      ),
    ]);
    bytes += generator.text(
      'IVA. INCLUIDO',
      styles: PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        align: PosAlign.left,
      ),
    );
    bytes += generator.row([
      PosColumn(
        text: (suma / 1.10).toStringAsFixed(2),
        width: 2,
        styles: PosStyles(align: PosAlign.center, underline: false),
      ),
      PosColumn(
        text: '10,00%',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: false),
      ),
      PosColumn(
        text: (suma - suma / 1.10).toStringAsFixed(2),
        width: 7,
        styles: PosStyles(align: PosAlign.left, underline: false),
      ),
    ]);
    bytes += generator.text('-' * 48);
    bytes += generator.text(
      _mensajeDespedida ?? "",
      styles: PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        align: PosAlign.center,
      ),
    );
    bytes += generator.emptyLines(2);
    bytes += generator.cut();

    _printEscPos(bytes);
  }

  Future<void> _printEscPos(List<int> bytes) async {
    logger.i("Starting print job for printer: ${_selectedPrinter?.uniqueId}");
    if (_selectedPrinter == null) return;
    var bluetoothPrinter = _selectedPrinter!;

    switch (bluetoothPrinter.connectionType) {
      case ConnectionType.USB:
        await printerManager.printData(bluetoothPrinter, bytes);
        logger.i("Print job sent to USB printer: ${bluetoothPrinter.uniqueId}");
        break;
      case ConnectionType.BLE:
        await printerManager.printData(bluetoothPrinter, bytes);
        logger.i("Print job sent to BLE printer: ${bluetoothPrinter.uniqueId}");
        break;
      case ConnectionType.NETWORK:
        final service = FlutterThermalPrinterNetwork(
          _ipAddress,
          port: int.parse(_port),
        );
        await service.connect();
        await service.printTicket(bytes);
        await service.disconnect();
        logger.i("Print job sent to Network printer at $_ipAddress:$_port");
        break;
      default:
    }
  }

  Future<void> setWelcomeText(String text) async {
    _mensajeInicial = text;
    await Config.setWelcomeText(text);
    notifyListeners();
  }

  Future<void> setGoodbyeText(String text) async {
    _mensajeDespedida = text;
    await Config.setGoodbyeText(text);
    notifyListeners();
  }

  Future<void> setSelectedPrinterType(ConnectionType type) async {
    _selectedPrinterType = type;
    _selectedPrinter = null;
    _isConnected = false;
    scan();
  }
}
