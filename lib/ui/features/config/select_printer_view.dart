import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/services/printer/printer_service.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

class PrintConfigView extends StatefulWidget {
  const PrintConfigView({super.key});

  @override
  State<PrintConfigView> createState() => _PrintConfigViewState();
}

class _PrintConfigViewState extends State<PrintConfigView> {
  late final PrinterService _printerService = PrinterService();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();

  ///////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _printerService.setBLEConfig();
    });
    _printerService.scan();
  }

  @override
  void dispose() {
    super.dispose();
    _printerService.dispose();
    _ipController.dispose();
    _portController.dispose();
  }

  void editarMensaje() {
    TextEditingController controller = TextEditingController(
      text: _printerService.mensajeDespedida,
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
                _printerService.setGoodbyeText(controller.text);
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
      text: _printerService.mensajeInicial,
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
                _printerService.setWelcomeText(controller.text);
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
    return ListenableBuilder(
      listenable: _printerService,
      builder: (context, _) => Scaffold(
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
                            onPressed: () => _printerService.connectDevice(),
                            child: const Text(
                              "Connect",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _printerService.disconnectDevice(),
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
                    initialValue: _printerService.selectedPrinterType,
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
                          _printerService.setSelectedPrinterType(value!);
                    },
                  ),
                  Column(
                    children: _printerService.devices
                        .map(
                          (device) => ListTile(
                            title: Text('${device.name}'),
                            subtitle:
                                Platform.isAndroid &&
                                    _printerService.selectedPrinterType ==
                                        ConnectionType.USB
                                ? null
                                : Visibility(
                                    visible: !Platform.isWindows,
                                    child: Text("${device.address}"),
                                  ),
                            onTap: () {
                              _printerService.selectDevice(device);
                            },
                            leading:
                                _printerService.selectedPrinter != null &&
                                    ((device.connectionType ==
                                                    ConnectionType.USB &&
                                                Platform.isWindows
                                            ? device.name ==
                                                  _printerService
                                                      .selectedPrinter!
                                                      .name
                                            : device.vendorId != null &&
                                                  _printerService
                                                          .selectedPrinter!
                                                          .vendorId ==
                                                      device.vendorId) ||
                                        (device.address != null &&
                                            _printerService
                                                    .selectedPrinter!
                                                    .address ==
                                                device.address))
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            trailing: OutlinedButton(
                              onPressed:
                                  _printerService.selectedPrinter == null ||
                                      device.name !=
                                          _printerService.selectedPrinter?.name
                                  ? null
                                  : () async {
                                      _printerService.printTestTicket();
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
                        _printerService.selectedPrinterType ==
                            ConnectionType.NETWORK &&
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
                        onChanged: _printerService.setIpAddress,
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _printerService.selectedPrinterType ==
                            ConnectionType.NETWORK &&
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
                        onChanged: _printerService.setPort,
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _printerService.selectedPrinterType ==
                            ConnectionType.NETWORK &&
                        Platform.isWindows,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          if (_ipController.text.isNotEmpty) {
                            _printerService.setIpAddress(_ipController.text);
                          }
                          _printerService.printTestTicket();
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
                if (_printerService.isScanning) {
                  _printerService.stopScan();
                } else {
                  _printerService.scan();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  _printerService.isScanning ? Colors.red : Colors.green,
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
      ),
    );
  }
}
