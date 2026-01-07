import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/utils/config.dart' as config;

Future printReceive(List<OrderLine> orderLines, RestTable table) async {
  var reconnect = false;
  var printerManager = PrinterManager.instance;
  List<int>? pendingTask;
  BluetoothPrinter? selectedPrinter;
  List<int> bytes = [];
  selectedPrinter = BluetoothPrinter(
    address: config.Config.selectedPrinter,
    typePrinter: PrinterType.bluetooth,
    deviceName: "Unknown",
  );

  final profile = await CapabilityProfile.load();
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
  bytes += generator.text('-' * 48);
  bytes += generator.text(
    'Mesa:${table.number}',
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
  final profiles = await CapabilityProfile.getAvailableProfiles();
  print(profiles);
  for (var orderLine in orderLines) {
    var priceText = Uint8List.fromList('${orderLine.totalPrice}'.codeUnits + [128]);
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
  bytes += generator.text(
    'Text size 200%',
    styles: PosStyles(
      height: PosTextSize.size2,
      width: PosTextSize.size2,
      align: PosAlign.right,
    ),
  );

  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: UsbPrinterInput(
            name: bluetoothPrinter.deviceName,
            productId: bluetoothPrinter.productId,
            vendorId: bluetoothPrinter.vendorId,
          ),
        );
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: BluetoothPrinterInput(
            name: bluetoothPrinter.deviceName,
            address: bluetoothPrinter.address!,
            isBle: bluetoothPrinter.isBle ?? false,
            autoConnect: reconnect,
          ),
        );
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!),
        );
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (selectedPrinter.address != "") {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  _printEscPos(bytes, generator);
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter({
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.bluetooth,
    this.isBle = false,
  });
}
