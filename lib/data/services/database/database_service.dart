import 'package:flutter/foundation.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';

/// Owns the [AppDatabase] instance and allows swapping it out (e.g. after
/// importing a database backup). Registered at the root of the widget tree so
/// consumers resolve the current database via `context.read<DatabaseService>()`.
class DatabaseService extends ChangeNotifier {
  DatabaseService({AppDatabase Function()? open}) : _open = open ?? _openDefault {
    _database = _open();
  }

  static AppDatabase _openDefault() => AppDatabase();

  final AppDatabase Function() _open;
  late AppDatabase _database;

  AppDatabase get database => _database;

  /// Closes the current database so its backing file can be replaced. The
  /// process is split so import flows can pick/copy files between the close
  /// and the swap.
  Future<void> closeDatabase() async {
    await _database.close();
  }

  /// Replaces the current database with [newDatabase] and notifies listeners.
  void setDatabase(AppDatabase newDatabase) {
    _database = newDatabase;
    notifyListeners();
  }
}