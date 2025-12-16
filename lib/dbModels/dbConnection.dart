import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_proyect/dbModels/tables.dart';
import 'package:path_provider/path_provider.dart';

part 'dbConnection.g.dart';

@DriftDatabase(
  tables: [
    RestTables,
    ProductTypesTable,
    ProductsClass,
    Taxes,
    Orders,
    OrderLines,
    Payments,
  ],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        // Inserta datos iniciales solo si la DB fue creada
        await into(
          taxes,
        ).insert(TaxesCompanion.insert(name: "Normal", rate: 0.2));
      }
    },
    onUpgrade: (m, from, to) async {

  //    await transaction(
  //      () => VersionedSchema.runMigrationSteps(
  //        migrator: m,
  //        from: from,
  //        to: to,
  //        steps: _upgrade,
  //      ),
  //    );
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'new_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }

  //static final _upgrade = migrationSteps(


  //);
}
