import 'package:flutter/material.dart';
import 'package:flutter_proyect/mainWidget/table_view/select_printer_view.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferencias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Editar Impresora'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintConfigView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
