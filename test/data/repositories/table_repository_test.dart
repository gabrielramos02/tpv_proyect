import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late TableRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TableRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TableRepository', () {
    test('addTable inserts and getTables returns it', () async {
      await repository.addTable(number: '5');

      final tables = await repository.getTables();
      expect(tables, hasLength(1));
      expect(tables.first.number, '5');
      expect(tables.first.top, 10);
      expect(tables.first.left, 20);
      expect(tables.first.state, 0);
    });

    test('addTable honors custom position and state', () async {
      await repository.addTable(number: '7', top: 50, left: 60, state: 1);

      final tables = await repository.getTables();
      expect(tables.first.top, 50);
      expect(tables.first.left, 60);
      expect(tables.first.state, 1);
    });

    test('updateTable replaces table position/state', () async {
      await repository.addTable(number: '2', top: 10, left: 20);
      final table = (await repository.getTables()).single;

      await repository.updateTable(table.copyWith(top: 999, left: 111));

      final updated = (await repository.getTables()).single;
      expect(updated.top, 999);
      expect(updated.left, 111);
    });

    test('deleteTable removes only the given table', () async {
      await repository.addTable(number: '1', top: 10, left: 20);
      await repository.addTable(number: '2', top: 30, left: 40);

      final first = (await repository.getTables()).first;
      await repository.deleteTable(first.id);

      final tables = await repository.getTables();
      expect(tables, hasLength(1));
      expect(tables.single.number, '2');
    });

    test('deleteTable with unknown id is a no-op', () async {
      await repository.addTable(number: '1');
      await repository.deleteTable(999);

      expect(await repository.getTables(), hasLength(1));
    });
  });
}
