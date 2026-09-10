import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/domain/constants.dart';
import 'package:flutter_proyect/ui/features/table/view_models/split_table_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late OrderRepository orderRepository;
  late TableRepository tableRepository;
  late SplitTableModel viewModel;
  late int mesaId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db
        .into(db.restTables)
        .insert(
          RestTablesCompanion.insert(
            number: '0',
            top: 0,
            left: 0,
            state: 0,
          ).copyWith(id: const drift.Value(phantomTableId)),
        );
    tableRepository = TableRepository(db);
    await tableRepository.addTable(number: '1');
    mesaId = (await tableRepository.getTables())
        .singleWhere((t) => t.id != phantomTableId)
        .id;
    orderRepository = OrderRepository(db);
    viewModel = SplitTableModel(
      orderRepository: orderRepository,
      tableRepository: tableRepository,
      tableID: mesaId,
    );
  });

  tearDown(() {
    viewModel.dispose();
    db.close();
  });

  Future<OrderLine> addLine(
    int orderId,
    String name,
    double price, {
    int quantity = 1,
    double taxRate = 0.21,
  }) async {
    final line = await db
        .into(db.orderLines)
        .insertReturning(
          OrderLinesCompanion.insert(
            order: orderId,
            productName: name,
            currentPrice: price,
            totalPrice: price,
            taxRate: taxRate,
            taxPrice: taxRate * price,
            quantity: 1,
          ),
        );
    if (quantity > 1) {
      await orderRepository.updateOrderLineQuantity(line, quantity);
    }
    return line;
  }

  Future<void> seedLeft(
    String name, {
    int quantity = 1,
    double price = 10,
    double taxRate = 0.21,
  }) async {
    final order = await orderRepository.addNewOrder(mesaId, 0, 0);
    await addLine(order.id, name, price, quantity: quantity, taxRate: taxRate);
  }

  Future<void> seedRight(
    String name, {
    int quantity = 1,
    double price = 10,
    double taxRate = 0.21,
  }) async {
    if (viewModel.splitTableOrder == null) {
      await viewModel.newOrder();
    }
    await addLine(
      viewModel.splitTableOrder!.id,
      name,
      price,
      quantity: quantity,
      taxRate: taxRate,
    );
  }

  group('SplitTableModel', () {
    test('newOrder creates and persists the phantom split order', () async {
      await viewModel.newOrder();

      expect(viewModel.splitTableOrder, isNotNull);
      expect(viewModel.splitTableOrder!.restTable, phantomTableId);

      final persisted = await orderRepository.getOrderById(
        viewModel.splitTableOrder!.id,
      );
      expect(persisted, isNotNull);
    });

    test(
      'getRightLines auto-creates the split order when none exists',
      () async {
        expect(viewModel.splitTableOrder, isNull);

        await viewModel.getRightLines();

        expect(viewModel.splitTableOrder, isNotNull);
        expect(viewModel.rightList, isEmpty);
      },
    );

    test(
      'getLeftLines loads the open mesa lines and sets leftLineOrderId',
      () async {
        await seedLeft('Beer', quantity: 2);
        final mesaOrder = (await orderRepository.getOrders(mesaId)).single;

        await viewModel.getLeftLines();

        expect(viewModel.leftList, hasLength(1));
        expect(viewModel.leftList.single.productName, 'Beer');
        expect(viewModel.leftList.single.quantity, 2);
        expect(viewModel.leftLineOrderId, mesaOrder.id);
      },
    );

    test('getLeftLines flips isLoading around the fetch', () async {
      await seedLeft('Beer');
      expect(viewModel.isLoading, isFalse);

      final future = viewModel.getLeftLines();
      expect(viewModel.isLoading, isTrue);
      await future;

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.leftList, hasLength(1));
    });

    test('getRightLines flips isLoading around the fetch', () async {
      await seedRight('Wine');

      final future = viewModel.getRightLines();
      expect(viewModel.isLoading, isTrue);
      await future;

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.rightList.single.productName, 'Wine');
    });

    test('totals compute the price for each side', () async {
      await seedLeft('Beer', quantity: 2);
      await seedRight('Wine');
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.totalPrecioLeft, 20.0);
      expect(viewModel.totalPrecioRight, 10.0);
    });

    test('onMoveRight moves one unit to the split side', () async {
      await seedLeft('Beer', quantity: 2);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();
      expect(viewModel.rightList, isEmpty);

      await viewModel.onMoveRight(viewModel.leftList.single);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.leftList.single.quantity, 1);
      expect(viewModel.rightList.single.productName, 'Beer');
      expect(viewModel.rightList.single.quantity, 1);
      expect(viewModel.totalPrecioRight, 10.0);
    });

    test('onMoveRight merges and deletes the exhausted left line', () async {
      await seedLeft('Beer', quantity: 2);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      await viewModel.onMoveRight(viewModel.leftList.single);
      await viewModel.getLeftLines();
      await viewModel.onMoveRight(viewModel.leftList.single);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.leftList, isEmpty);
      expect(viewModel.rightList, hasLength(1));
      expect(viewModel.rightList.single.quantity, 2);
      expect(viewModel.rightList.single.currentPrice, 10.0);
    });

    test('onMoveRight keeps different products as separate lines', () async {
      final order = await orderRepository.addNewOrder(mesaId, 0, 0);
      await addLine(order.id, 'Beer', 10);
      await addLine(order.id, 'Wine', 10);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      await viewModel.onMoveRight(viewModel.leftList.first);
      await viewModel.onMoveRight(viewModel.leftList.last);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.leftList, isEmpty);
      expect(viewModel.rightList.map((e) => e.productName), ['Beer', 'Wine']);
    });

    test('onMoveLeft moves a unit back to the mesa side', () async {
      await seedLeft('Beer');
      await seedRight('Wine');
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      await viewModel.onMoveLeft(viewModel.rightList.single);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.rightList, isEmpty);
      expect(viewModel.leftList.map((e) => e.productName), ['Beer', 'Wine']);
      expect(viewModel.leftList.last.quantity, 1);
    });

    test('onMoveLeft merges into an existing mesa line', () async {
      await seedLeft('Beer', quantity: 2);
      await seedRight('Beer');
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      await viewModel.onMoveLeft(viewModel.rightList.single);
      await viewModel.getLeftLines();
      await viewModel.getRightLines();

      expect(viewModel.rightList, isEmpty);
      expect(viewModel.leftList, hasLength(1));
      expect(viewModel.leftList.single.quantity, 3);
    });

    test(
      'preCheckout settles both orders and returns the phantom table',
      () async {
        await seedLeft('Beer', quantity: 2);
        await seedRight('Wine');
        await viewModel.getRightLines();
        final splitOrderId = viewModel.splitTableOrder!.id;

        final ghost = await viewModel.preCheckout();

        expect(ghost.id, phantomTableId);
        expect(ghost.number, '0');
        expect(ghost.state, 0);

        final mesaOrder = (await orderRepository.getOrders(mesaId)).single;
        expect(mesaOrder.totalPrice, 20.0);
        expect(mesaOrder.closedAt, isNull);

        final splitOrder = await orderRepository.getOrderById(splitOrderId);
        expect(splitOrder!.totalPrice, 10.0);
        expect(splitOrder.closedAt, isNull);
      },
    );

    test(
      'postCheckout creates a new split order when the old one is paid off',
      () async {
        await seedLeft('Beer', quantity: 2);
        await seedRight('Wine');
        await viewModel.preCheckout();
        final oldSplitId = viewModel.splitTableOrder!.id;
        await db
            .into(db.payments)
            .insert(
              PaymentsCompanion.insert(
                paymentMethod: 'efectivo',
                payedAmount: 10,
                order: oldSplitId,
              ),
            );

        await viewModel.postCheckout();
        await viewModel.getRightLines();

        expect(viewModel.splitTableOrder!.id, isNot(oldSplitId));
        expect(viewModel.rightList, isEmpty);
      },
    );

    test('postCheckout keeps the split order while it is open', () async {
      await seedLeft('Beer');
      await seedRight('Wine');
      await viewModel.preCheckout();
      final oldSplitId = viewModel.splitTableOrder!.id;

      await viewModel.postCheckout();
      await viewModel.getRightLines();

      expect(viewModel.splitTableOrder!.id, oldSplitId);
      expect(viewModel.rightList.single.productName, 'Wine');
    });
  });
}
