import 'package:flutter_proyect/data/services/database/dbConnection.dart';

class TableRepository {
  const TableRepository(this._db);

  final AppDatabase _db;

  Future<List<RestTable>> getTables() {
    return _db.select(_db.restTables).get();
  }

  Future<void> updateTable(RestTable table) {
    return _db.update(_db.restTables).replace(table);
  }

  Future<void> addTable({
    required String number,
    double top = 10,
    double left = 20,
    int state = 0,
  }) {
    return _db
        .into(_db.restTables)
        .insert(
          RestTablesCompanion.insert(
            number: number,
            top: top,
            left: left,
            state: state,
          ),
        );
  }

  Future<void> deleteTable(int id) {
    return (_db.delete(_db.restTables)..where((e) => e.id.isValue(id))).go();
  }
}
