import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/order_repository.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/repositories/table_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_proyect/domain/constants.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/add_types_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/edit_products_form.dart';
import 'package:flutter_proyect/ui/features/table/forms/free_price_form.dart';
import 'package:flutter_proyect/ui/features/table/view_models/table_view.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late OrderRepository orderRepository;
  late TableRepository tableRepository;
  late ProductRepository productRepository;
  late TableViewModel viewModel;
  late int mesaId;
  late int taxId;
  late int productTypeId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tableRepository = TableRepository(db);
    orderRepository = OrderRepository(db);
    productRepository = ProductRepository(db);

    await tableRepository.addTable(number: '1');
    mesaId = (await tableRepository.getTables()).first.id;

    taxId = await db.into(db.taxes).insert(
          TaxesCompanion.insert(name: 'IVA', rate: 0.21),
        );

    productTypeId = await db.into(db.productTypesTable).insert(
          ProductTypesTableCompanion.insert(
            name: 'Drinks',
            order: 0,
            color: '#000000',
          ),
        );

    final table = (await tableRepository.getTables())
        .singleWhere((t) => t.id == mesaId);
    viewModel = TableViewModel(
      orderRepository: orderRepository,
      tableRepository: tableRepository,
      productRepository: productRepository,
      table: table,
    );
    await viewModel.initialize();
  });

  tearDown(() {
    viewModel.dispose();
    db.close();
  });

  Future<int> addProduct({
    String name = 'Beer',
    double price = 10,
    int type = 0,
    int? taxes,
  }) async {
    return db.into(db.productsClass).insert(
          ProductsClassCompanion.insert(
            name: name,
            price: price,
            type: type == 0 ? productTypeId : type,
            taxes: taxes ?? taxId,
            order: 0,
            color: '#000000',
          ),
        );
  }

  Future<Order> addOrder({double totalPrice = 0}) async {
    return orderRepository.addNewOrder(mesaId, totalPrice, 0.21);
  }

  Future<OrderLine> addLine(
    int orderId,
    String name,
    double price, {
    int quantity = 1,
  }) async {
    final line = await db
        .into(db.orderLines)
        .insertReturning(
          OrderLinesCompanion.insert(
            order: orderId,
            productName: name,
            currentPrice: price,
            totalPrice: price,
            taxRate: 0.21,
            taxPrice: 0.21 * price,
            quantity: 1,
          ),
        );
    if (quantity > 1) {
      await orderRepository.updateOrderLineQuantity(line, quantity);
    }
    return line;
  }

  ProductsClassData productFromDb(int id, {String name = 'Beer', double price = 10}) {
    return ProductsClassData(
      id: id,
      name: name,
      price: price,
      color: '#000000',
      order: 0,
      type: productTypeId,
      taxes: taxId,
    );
  }

  group('TableViewModel', () {
    group('initialize', () {
      test('loads orderLines, productTypes and products', () async {
        await addProduct();
        final order = await addOrder();
        await addLine(order.id, 'Beer', 10);

        await viewModel.initialize();

        expect(viewModel.orderLines, hasLength(1));
        expect(viewModel.orderLines.single.productName, 'Beer');
        expect(viewModel.productTypes, hasLength(1));
        expect(viewModel.productTypes.single.name, 'Drinks');
        expect(viewModel.products, hasLength(1));
        expect(viewModel.products.single.name, 'Beer');
      });

      test('isLoading flips during initialize', () async {
        expect(viewModel.isLoading, isFalse);

        final future = viewModel.initialize();
        expect(viewModel.isLoading, isTrue);
        await future;

        expect(viewModel.isLoading, isFalse);
      });
    });

    group('getLines', () {
      test('loads order lines for the table', () async {
        final order = await addOrder();
        await addLine(order.id, 'Beer', 10, quantity: 2);
        await addLine(order.id, 'Wine', 5);

        await viewModel.getLines();

        expect(viewModel.orderLines, hasLength(2));
      });

      test('excludes lines from other tables', () async {
        await tableRepository.addTable(number: '2');
        final otherTable =
            (await tableRepository.getTables()).last;
        final otherOrder =
            await orderRepository.addNewOrder(otherTable.id, 0, 0.21);
        await addLine(otherOrder.id, 'Rum', 8);

        final order = await addOrder();
        await addLine(order.id, 'Beer', 10);

        await viewModel.getLines();

        expect(viewModel.orderLines, hasLength(1));
        expect(viewModel.orderLines.single.productName, 'Beer');
      });

      test('isLoading flips around getLines', () async {
        final order = await addOrder();
        await addLine(order.id, 'Beer', 10);

        final future = viewModel.getLines();
        expect(viewModel.isLoading, isTrue);
        await future;

        expect(viewModel.isLoading, isFalse);
      });
    });

    group('getProductTypes', () {
      test('loads product types', () async {
        await viewModel.getProductTypes();

        expect(viewModel.productTypes, hasLength(1));
        expect(viewModel.productTypes.single.name, 'Drinks');
      });
    });

    group('getProducts', () {
      test('loads products', () async {
        await addProduct(name: 'Beer');
        await addProduct(name: 'Wine', price: 5);

        await viewModel.getProducts();

        expect(viewModel.products, hasLength(2));
      });
    });

    group('selectType', () {
      test('updates selectedType and notifies', () async {
        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.selectType(42);

        expect(viewModel.selectedType, 42);
        expect(notified, isTrue);
      });

      test('defaults to allProductTypesId', () {
        expect(viewModel.selectedType, allProductTypesId);
      });
    });

    group('onChangePriceText', () {
      test('updates priceText and notifies', () async {
        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.onChangePriceText('25.5');

        expect(viewModel.priceText, '25.5');
        expect(notified, isTrue);
      });
    });

    group('onEditProductList / onCancelEditProductList', () {
      test('onEditProductList sets editedProduct', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);

        viewModel.onEditProductList(line);

        expect(viewModel.editedProduct, isNotNull);
        expect(viewModel.editedProduct!.id, line.id);
      });

      test('onCancelEditProductList clears editedProduct', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);
        viewModel.onEditProductList(line);

        viewModel.onCancelEditProductList();

        expect(viewModel.editedProduct, isNull);
      });
    });

    group('onTapProduct', () {
      test('creates new order and line when table is empty', () async {
        await addProduct(name: 'Beer', price: 10);
        final product = productFromDb(0, name: 'Beer', price: 10);

        await viewModel.onTapProduct(product);

        final orders = await orderRepository.getOrders(mesaId);
        expect(orders, hasLength(1));
        expect(viewModel.orderLines, hasLength(1));
        expect(viewModel.orderLines.single.productName, 'Beer');
        expect(viewModel.orderLines.single.currentPrice, 10.0);
      });

      test('adds new line to existing order', () async {
        final productId1 = await addProduct(name: 'Beer', price: 10);
        final productId2 = await addProduct(name: 'Wine', price: 5);
        final product1 = productFromDb(productId1, name: 'Beer', price: 10);
        final product2 = productFromDb(productId2, name: 'Wine', price: 5);

        await viewModel.onTapProduct(product1);
        await viewModel.onTapProduct(product2);

        final orders = await orderRepository.getOrders(mesaId);
        expect(orders, hasLength(1));
        expect(viewModel.orderLines, hasLength(2));
      });

      test('increments quantity for same product at same price', () async {
        final productId = await addProduct(name: 'Beer', price: 10);
        final product = productFromDb(productId, name: 'Beer', price: 10);

        await viewModel.onTapProduct(product);
        await viewModel.onTapProduct(product);

        expect(viewModel.orderLines, hasLength(1));
        expect(viewModel.orderLines.single.quantity, 2);
      });

      test('uses priceText override when set', () async {
        final productId = await addProduct(name: 'Beer', price: 10);
        final product = productFromDb(productId, name: 'Beer', price: 10);
        viewModel.onChangePriceText('25.5');

        await viewModel.onTapProduct(product);

        expect(viewModel.orderLines.single.currentPrice, 25.5);
      });

      test('isLoading flips around onTapProduct', () async {
        final productId = await addProduct(name: 'Beer', price: 10);
        final product = productFromDb(productId, name: 'Beer', price: 10);

        final future = viewModel.onTapProduct(product);
        expect(viewModel.isLoading, isTrue);
        await future;

        expect(viewModel.isLoading, isFalse);
      });
    });

    group('onAddProductType', () {
      test('adds a product type', () async {
        final response = AddTypesFormResponse(
          productName: 'Food',
          productOrder: 1,
          productColor: '#FF0000',
        );

        await viewModel.onAddProductType(response);

        expect(viewModel.productTypes, hasLength(2));
        expect(
          viewModel.productTypes.map((e) => e.name),
          contains('Food'),
        );
      });

      test('does nothing when cancelled', () async {
        final response = AddTypesFormResponse(isCancelled: true);

        await viewModel.onAddProductType(response);

        expect(viewModel.productTypes, hasLength(1));
      });
    });

    group('onEditProductType', () {
      test('renames a product type', () async {
        final type = viewModel.productTypes.single;

        await viewModel.onEditProductType(type, 'New Name');

        final updated = (await productRepository.getProductTypes())
            .singleWhere((t) => t.id == type.id);
        expect(updated.name, 'New Name');
      });

      test('deletes a product type when newName is empty', () async {
        final type = viewModel.productTypes.single;

        await viewModel.onEditProductType(type, '');

        final types = await productRepository.getProductTypes();
        expect(types, isEmpty);
      });

      test('does nothing when newName is null', () async {
        final type = viewModel.productTypes.single;

        await viewModel.onEditProductType(type, null);

        final types = await productRepository.getProductTypes();
        expect(types, hasLength(1));
      });
    });

    group('onAddProduct', () {
      test('adds a product', () async {
        final response = AddProductsFormResponse(
          isCancelled: false,
          name: 'Water',
          price: 2,
          type: productTypeId,
          taxes: taxId,
          order: 0,
          color: '#0000FF',
        );

        await viewModel.onAddProduct(response);

        expect(viewModel.products, hasLength(1));
        expect(viewModel.products.single.name, 'Water');
      });

      test('does nothing when cancelled', () async {
        final response = AddProductsFormResponse(isCancelled: true);

        await viewModel.onAddProduct(response);

        expect(viewModel.products, isEmpty);
      });
    });

    group('onEditProduct', () {
      test('updates a product', () async {
        final productId = await addProduct(name: 'Beer', price: 10);
        await viewModel.getProducts();
        final product = viewModel.products.single;

        final response = EditProductsFormResponse(
          isDeleted: false,
          name: 'Cold Beer',
          price: 12,
        );

        await viewModel.onEditProduct(response, product);

        final updated = viewModel.products.singleWhere((p) => p.id == productId);
        expect(updated.name, 'Cold Beer');
        expect(updated.price, 12.0);
      });

      test('deletes a product', () async {
        await addProduct(name: 'Beer');
        await viewModel.getProducts();
        final product = viewModel.products.single;

        final response = EditProductsFormResponse(isDeleted: true);

        await viewModel.onEditProduct(response, product);

        expect(viewModel.products, isEmpty);
      });
    });

    group('onSaveEditProductList', () {
      test('updates the price of the edited product', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);
        viewModel.onEditProductList(line);

        await viewModel.onSaveEditProductList(
          FreePriceResult(price: '25'),
        );

        expect(viewModel.orderLines.single.currentPrice, 25.0);
      });

      test('does nothing when result price is 0', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);
        viewModel.onEditProductList(line);

        await viewModel.onSaveEditProductList(
          FreePriceResult(price: '0'),
        );

        expect(viewModel.orderLines.single.currentPrice, 10.0);
      });
    });

    group('onRemoveProductFromList', () {
      test('removes the product line', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);
        await viewModel.getLines();

        await viewModel.onRemoveProductFromList(line);

        expect(viewModel.orderLines, isEmpty);
        expect(viewModel.editedProduct, isNull);
      });
    });

    group('onAddProductUnitFromList', () {
      test('increments quantity by 1', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10, quantity: 1);
        await viewModel.getLines();

        await viewModel.onAddProductUnitFromList(line);

        expect(viewModel.orderLines.single.quantity, 2);
      });
    });

    group('onRemoveProductUnitFromList', () {
      test('decrements quantity when > 1', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10, quantity: 3);
        await viewModel.getLines();

        await viewModel.onRemoveProductUnitFromList(line);

        expect(viewModel.orderLines.single.quantity, 2);
      });

      test('deletes line when quantity is 1', () async {
        final order = await addOrder();
        final line = await addLine(order.id, 'Beer', 10);
        await viewModel.getLines();

        await viewModel.onRemoveProductUnitFromList(line);

        expect(viewModel.orderLines, isEmpty);
      });
    });

    group('onDeleteTable', () {
      test('removes all order lines for the table', () async {
        final order = await addOrder();
        await addLine(order.id, 'Beer', 10);
        await addLine(order.id, 'Wine', 5);
        await viewModel.getLines();

        await viewModel.onDeleteTable();
        await viewModel.getLines();

        expect(viewModel.orderLines, isEmpty);
      });
    });

    group('updateOrders', () {
      test('calls orderRepository.updateOrders', () async {
        final order = await addOrder();
        await addLine(order.id, 'Beer', 10);

        await viewModel.updateOrders();

        final updated = await orderRepository.getOrderById(order.id);
        expect(updated, isNotNull);
        expect(updated!.totalPrice, 10.0);
      });
    });
  });
}
