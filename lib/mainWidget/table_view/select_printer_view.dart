import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_proyect/utils/config.dart';
import 'package:flutter_proyect/utils/logger.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintConfigView extends StatefulWidget {
  const PrintConfigView({super.key});

  @override
  State<PrintConfigView> createState() => _PrintConfigViewState();
}

class _PrintConfigViewState extends State<PrintConfigView> {
  final printerManager = FlutterThermalPrinter.instance;
  List<ConnectionType> connections = <ConnectionType>[
    ConnectionType.BLE,
    ConnectionType.NETWORK,
  ];
  ConnectionType defaultPrinterType = ConnectionType.BLE;
  bool _isConnected = false;
  bool _isScanning = false;
  List<Printer> devices = <Printer>[];
  StreamSubscription<List<Printer>>? _subscription;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  Printer? selectedPrinter;
  String? _mensajeDespedida = "";
  String? _mensajeInicial = "";

  ///////////////////////////////////////////
  void _scan() async {
    if (Platform.isAndroid) {
      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }
      // Android 11 o inferior (necesario para escanear Bluetooth Classic)
      if (await Permission.locationWhenInUse.isDenied) {
        await Permission.locationWhenInUse.request();
      }
    }
    logger.i("Scanning for printers with connection types: $connections");
    _isScanning = true;
    await printerManager.getPrinters(connectionTypes: connections);
    _subscription = printerManager.devicesStream.listen((List<Printer> event) {
      setState(() {
        devices = event;
        devices.removeWhere(
          ((element) =>
              element.name == null ||
              element.name == '' ||
              element.name!.toLowerCase().contains("print") == false),
        );
      });
    });
  }

  void stopScan() {
    logger.i("Stopping printer scan");
    printerManager.stopScan();
    _isScanning = false;
  }

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = ConnectionType.USB;
    super.initState();
    _mensajeInicial = Config.welcomeText;
    _mensajeDespedida = Config.goodbyeText;
    _portController.text = _port;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      printerManager.bleConfig = const BleConfig(
        connectionStabilizationDelay: Duration(seconds: 3),
      );
      _scan();
    });
    setState(() {});
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

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

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = Printer(
      name: value,
      address: _ipAddress,
      connectionType: ConnectionType.NETWORK,
    );
    selectDevice(device);
  }

  void selectDevice(Printer device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.connectionType == ConnectionType.USB &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await printerManager.disconnect(selectedPrinter!);
      }
    }

    selectedPrinter = device;
    setState(() {});
  }

  Future _printReceiveTest() async {
    logger.i("Preparing test print for printer: ${selectedPrinter?.uniqueId}");
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

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    logger.i("Starting print job for printer: ${selectedPrinter?.uniqueId}");
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.connectionType) {
      case ConnectionType.USB:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.printData(bluetoothPrinter, bytes);
        pendingTask = null;
        logger.i("Print job sent to USB printer: ${bluetoothPrinter.uniqueId}");
        break;
      case ConnectionType.BLE:
        bytes += generator.cut();
        await printerManager.printData(bluetoothPrinter, bytes);
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        logger.i("Print job sent to BLE printer: ${bluetoothPrinter.uniqueId}");
        break;
      case ConnectionType.NETWORK:
        bytes += generator.feed(2);
        bytes += generator.cut();
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

  // conectar dispositivo
  void _connectDevice() async {
    stopScan();
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.connectionType) {
      case ConnectionType.USB:
        await printerManager.connect(selectedPrinter!);
        _isConnected = true;
        break;
      case ConnectionType.BLE:
        await printerManager.connect(selectedPrinter!);
        _isConnected = true;
        break;
      default:
    }
    logger.i("Connected to printer: ${selectedPrinter?.uniqueId}");
    setState(() {});
  }

  void editarMensaje() {
    // Controlador para capturar el texto, iniciamos con el valor actual
    TextEditingController controller = TextEditingController(
      text: _mensajeDespedida,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Despedida'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Escribe el nuevo mensaje",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Config.setGoodbyeText(controller.text);
                setState(() {
                  _mensajeDespedida = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void editarMensajeInicial() {
    TextEditingController controller = TextEditingController(
      text: _mensajeInicial,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Mensaje Inicial'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Escribe el nuevo mensaje",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Config.setWelcomeText(controller.text);
                setState(() {
                  _mensajeInicial = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        content: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedPrinter == null || _isConnected
                              ? null
                              : () {
                                  _connectDevice();
                                },
                          child: const Text(
                            "Connect",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedPrinter == null || !_isConnected
                              ? null
                              : () {
                                  if (selectedPrinter != null) {
                                    printerManager.disconnect(selectedPrinter!);
                                  }
                                  setState(() {
                                    _isConnected = false;
                                  });
                                },
                          child: const Text(
                            "Disconnect",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            editarMensajeInicial();
                          },
                          child: const Text(
                            "Editar Mensaje Inicial",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            editarMensaje();
                          },
                          child: const Text(
                            "Editar Mensaje Final",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButtonFormField<ConnectionType>(
                  initialValue: defaultPrinterType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.print, size: 24),
                    labelText: "Type Printer Device",
                    labelStyle: TextStyle(fontSize: 18.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  items: <DropdownMenuItem<ConnectionType>>[
                    const DropdownMenuItem(
                      value: ConnectionType.BLE,
                      child: Text("bluetooth"),
                    ),
                    const DropdownMenuItem(
                      value: ConnectionType.USB,
                      child: Text("usb"),
                    ),
                    const DropdownMenuItem(
                      value: ConnectionType.NETWORK,
                      child: Text("Wifi"),
                    ),
                  ],
                  onChanged: (ConnectionType? value) {
                    setState(() {
                      if (value != null) {
                        setState(() {
                          defaultPrinterType = value;
                          selectedPrinter = null;
                          _isConnected = false;
                          _scan();
                        });
                      }
                    });
                  },
                ),
                Column(
                  children: devices
                      .map(
                        (device) => ListTile(
                          title: Text('${device.name}'),
                          subtitle:
                              Platform.isAndroid &&
                                  defaultPrinterType == ConnectionType.USB
                              ? null
                              : Visibility(
                                  visible: !Platform.isWindows,
                                  child: Text("${device.address}"),
                                ),
                          onTap: () {
                            Config.setPrinter(device);
                            selectDevice(device);
                          },
                          leading:
                              selectedPrinter != null &&
                                  ((device.connectionType ==
                                                  ConnectionType.USB &&
                                              Platform.isWindows
                                          ? device.name == selectedPrinter!.name
                                          : device.vendorId != null &&
                                                selectedPrinter!.vendorId ==
                                                    device.vendorId) ||
                                      (device.address != null &&
                                          selectedPrinter!.address ==
                                              device.address))
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          trailing: OutlinedButton(
                            onPressed:
                                selectedPrinter == null ||
                                    device.name != selectedPrinter?.name
                                ? null
                                : () async {
                                    _printReceiveTest();
                                  },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 20,
                              ),
                              child: Text(
                                "Print test ticket",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Visibility(
                  visible:
                      defaultPrinterType == ConnectionType.NETWORK &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _ipController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        label: Text("Ip Address"),
                        prefixIcon: Icon(Icons.wifi, size: 24),
                      ),
                      onChanged: setIpAddress,
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      defaultPrinterType == ConnectionType.NETWORK &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _portController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        label: Text("Port"),
                        prefixIcon: Icon(Icons.numbers_outlined, size: 24),
                      ),
                      onChanged: setPort,
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      defaultPrinterType == ConnectionType.NETWORK &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_ipController.text.isNotEmpty) {
                          setIpAddress(_ipController.text);
                        }
                        _printReceiveTest();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 50,
                        ),
                        child: Text(
                          "Print test ticket",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_isScanning) {
                stopScan();
              } else {
                _scan();
              }
              setState(() {});
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                _isScanning ? Colors.red : Colors.green,
              ),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: const Text('Toggle Scan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
