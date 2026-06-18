import 'dart:io';
import 'package:flutter_proyect/dbModels/dbConnection.dart';
import 'package:flutter_proyect/main.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyect/mainWidget/table_view/select_printer_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({super.key});

  Future<void> createDatabaseBackup(DatabaseConnectionUser database) async {
    final choosenDirectory = await FilePicker.getDirectoryPath();
    if (choosenDirectory == null) return;

    final parent = Directory(choosenDirectory);
    final file = File(p.join(choosenDirectory, 'drift_example_backup.db'));

    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }
    if (await file.exists()) {
      await file.delete();
    }

    await database.customStatement('VACUUM INTO ?', [file.absolute.path]);
  }

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
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Exportar Base de Datos'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              createDatabaseBackup(database);
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Importar Base de Datos'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              await database.close();

              final backupFile = await FilePicker.pickFiles();
              if (backupFile == null) return;

              final backupPath = backupFile.files.single.path;
              if (backupPath == null) {
                return; // Seguridad por si el path es nulo
              }
              final backupDb = sqlite3.open(backupPath);

              final tempPath = await getTemporaryDirectory();
              final tempDb = p.join(tempPath.path, 'import.db');
              backupDb
                ..execute('VACUUM INTO ?', [tempDb])
                ..close();

              final tempDbFile = File(tempDb);

              final appDir = await getApplicationSupportDirectory();
              final dbPath = p.join(appDir.path, 'new_db.sqlite');
              final databaseFile = File(dbPath);
              await tempDbFile.copy((databaseFile).path);
              await tempDbFile.delete();

              database = AppDatabase();
            },
          ),
        ],
      ),
    );
  }
}
