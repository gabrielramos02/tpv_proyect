import 'package:flutter/material.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/ui/features/config/select_printer_view.dart';
import 'package:flutter_proyect/ui/features/config/view_models/config_view_models.dart';
import 'package:provider/provider.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  late final ConfigViewModel _viewModel = ConfigViewModel(
    context.read<DatabaseService>(),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
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
                      await showDialog(
                        context: context,
                        builder: (context) => const PrintConfigView(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Exportar Base de Datos'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      await _viewModel.createDatabaseBackup();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.input),
                    title: const Text('Importar Base de Datos'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      await _viewModel.importDatabase();
                    },
                  ),
                ],
              ),
            ),
            if (_viewModel.isLoading)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
