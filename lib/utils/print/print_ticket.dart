import 'dart:io';
import 'package:drift/drift.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/mainWidget/table_view/select_printer_view.dart';
import 'package:flutter_proyect/utils/config.dart' as config;
import 'package:flutter_proyect/main.dart';

Future printReceive(List<OrderLine> orderLines, String number) async {
  var reconnect = false;
  var printerManager = PrinterManager.instance;
  List<int>? pendingTask;
  BluetoothPrinter? selectedPrinter;
  List<int> bytes = [];
  selectedPrinter = config.Config.selectedPrinter;
  String? GOODBYE_MSG = config.Config.goodbyeText?.toUpperCase();
  String? INFO_MSG = config.Config.welcomeText?.toUpperCase();

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
  bytes += generator.text(
    INFO_MSG ?? "",
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
    var priceText = Uint8List.fromList(
      linePrice.codeUnits + [128],
    );
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
  Ticket ticket = await database
      .into(database.tickets)
      .insertReturning(TicketsCompanion.insert(totalPrice: suma));
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
      text: 'N°${ticket.id.toString().padLeft(8, '0')}',
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
    GOODBYE_MSG ?? "",
    styles: PosStyles(
      height: PosTextSize.size1,
      width: PosTextSize.size1,
      align: PosAlign.center,
    ),
  );
  bytes += generator.emptyLines(2);

  void printEscPos(List<int> bytes, Generator generator) async {
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
        bool sucessfullPrint = await printerManager.send(
          type: bluetoothPrinter.typePrinter,
          bytes: bytes,
        );
        if (!sucessfullPrint) {
          await (database.delete(
            database.tickets,
          )..whereSamePrimaryKey(ticket)).go();
        }
        print(sucessfullPrint);

        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  printEscPos(bytes, generator);
}
