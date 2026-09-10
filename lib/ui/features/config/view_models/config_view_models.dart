import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_proyect/data/services/database/database_service.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class ConfigViewModel extends ChangeNotifier {
  ConfigViewModel(this._database);

  final DatabaseService _database;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> createDatabaseBackup() async {
    _isLoading = true;
    notifyListeners();
    try {
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

      await _database.database.customStatement('VACUUM INTO ?', [
        file.absolute.path,
      ]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> importDatabase() async {
    _isLoading = true;
    notifyListeners();
    try {
      final backupFile = await FilePicker.pickFiles();
      final backupPath = backupFile.single.path;
      if (backupPath == null) {
        return;
      }
      final backupDb = sqlite3.open(backupPath);

      final tempPath = await getTemporaryDirectory();
      final tempDb = p.join(tempPath.path, 'import.db');
      backupDb
        ..execute('VACUUM INTO ?', [tempDb])
        ..close();

      final tempDbFile = File(tempDb);

      // close database
      _database.closeDatabase();

      final appDir = await getApplicationSupportDirectory();
      final dbPath = p.join(appDir.path, 'new_db.sqlite');
      final databaseFile = File(dbPath);
      await tempDbFile.copy(databaseFile.path);
      await tempDbFile.delete();

      _database.setDatabase(AppDatabase());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
