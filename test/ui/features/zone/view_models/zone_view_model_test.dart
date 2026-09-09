import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/ui/features/zone/view_models/zone_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late TableRepository repository;
  late ZoneViewModel viewModel;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TableRepository(db);
    viewModel = ZoneViewModel(repository);
  });

  tearDown(() {
    viewModel.dispose();
    db.close();
  });

  group('ZoneViewModel', () {
    test('loadTables returns the persisted tables', () async {
      await repository.addTable(number: '1', top: 10, left: 20);
      await repository.addTable(number: '2', top: 30, left: 40);

      await viewModel.loadTables();

      expect(viewModel.tables, hasLength(2));
      expect(viewModel.tables.map((t) => t.number), ['1', '2']);
    });

    test('loadTables flips isLoading around the fetch', () async {
      expect(viewModel.isLoading, isFalse);

      final future = viewModel.loadTables();
      expect(viewModel.isLoading, isTrue);
      await future;

      expect(viewModel.isLoading, isFalse);
    });

    test('addTable inserts and refreshes the list', () async {
      await viewModel.addTable('5');

      expect(viewModel.tables, hasLength(1));
      expect(viewModel.tables.single.number, '5');

      await repository.addTable(number: '6');
      await viewModel.loadTables();
      expect(viewModel.tables, hasLength(2));
    });

    test('deleteTable removes only the given table and exits delete mode',
        () async {
      await viewModel.addTable('1');
      await viewModel.addTable('2');
      final toDelete = await repository.getTables();
      viewModel.toggleDeleteMode();
      expect(viewModel.deleteMode, isTrue);

      await viewModel.deleteTable(toDelete.first.id);

      expect(viewModel.tables, hasLength(1));
      expect(viewModel.tables.single.number, '2');
      expect(viewModel.deleteMode, isFalse);
    });

    test('toggleDeleteMode flips deleteMode', () {
      expect(viewModel.deleteMode, isFalse);
      viewModel.toggleDeleteMode();
      expect(viewModel.deleteMode, isTrue);
      viewModel.toggleDeleteMode();
      expect(viewModel.deleteMode, isFalse);
    });

    test('snapPosition snaps to the grid', () {
      final table = RestTable(id: 1, top: 0, left: 0, state: 0, number: '1');

      final snapped = viewModel.snapPosition(table, 81, 256);

      expect(snapped.top, 200.0);
      expect(snapped.left, 90.0);
    });

    test('snapPosition with negative deltas snaps to zero', () {
      final table = RestTable(id: 1, top: 999, left: 999, state: 0, number: '1');

      final snapped = viewModel.snapPosition(table, 14, 55);

      expect(snapped.top, 0.0);
      expect(snapped.left, 0.0);
    });

    test('moveTable persists the snapped position and refreshes', () async {
      await viewModel.addTable('1');
      final original = viewModel.tables.single;

      await viewModel.moveTable(original, 81, 256);

      final updated = viewModel.tables.single;
      expect(updated.top, 200.0);
      expect(updated.left, 90.0);

      final persisted = (await repository.getTables()).single;
      expect(persisted.top, 200.0);
      expect(persisted.left, 90.0);
    });
  });
}