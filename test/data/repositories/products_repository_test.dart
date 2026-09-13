import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_proyect/data/repositories/products_repository.dart';
import 'package:flutter_proyect/data/services/database/dbConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late ProductRepository repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repository = ProductRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<Taxe> getSeededTax() async {
    final taxes = await repository.getTaxes();
    return taxes.single;
  }

  Future<int> addBebeType() {
    return db.into(db.productTypesTable).insertReturning(
      ProductTypesTableCompanion.insert(
        name: 'Bebidas',
        order: 1,
        color: '#2196F3',
      ),
    ).then((type) => type.id);
  }

  group('ProductRepository', () {
    test('getTaxes returns the seeded default tax', () async {
      final taxes = await repository.getTaxes();

      expect(taxes, hasLength(1));
      expect(taxes.single.name, 'Normal');
      expect(taxes.single.rate, 0.2);
    });

    test('getTaxById returns the requested tax', () async {
      final tax = await getSeededTax();

      final result = await repository.getTaxById(tax.id);

      expect(result.id, tax.id);
      expect(result.rate, 0.2);
    });

    test('addProductType inserts and getProductTypes returns it', () async {
      await repository.addProductType('Bebidas', 1, '#2196F3');

      final types = await repository.getProductTypes();
      expect(types, hasLength(1));
      expect(types.single.id, greaterThan(0));
      expect(types.single.name, 'Bebidas');
      expect(types.single.order, 1);
      expect(types.single.color, '#2196F3');
    });

    test('updateProductTypeName renames the type', () async {
      final id = await addBebeType();

      await repository.updateProductTypeName(id, 'Bebidas Frias');

      final types = await repository.getProductTypes();
      expect(types.single.name, 'Bebidas Frias');
    });

    test('deleteProductType removes only the given type', () async {
      final id = await addBebeType();
      await repository.addProductType('Comida', 2, '#4CAF50');

      await repository.deleteProductType(id);

      final types = await repository.getProductTypes();
      expect(types, hasLength(1));
      expect(types.single.name, 'Comida');
    });

    test('addProduct inserts a product with type and tax references', () async {
      final typeId = await addBebeType();
      final tax = await getSeededTax();

      await repository.addProduct(
        name: 'Coca Cola',
        price: 2.5,
        type: typeId,
        taxes: tax.id,
        order: 3,
        color: '#000000',
      );

      final products = await repository.getProducts();
      expect(products, hasLength(1));
      expect(products.single.name, 'Coca Cola');
      expect(products.single.price, 2.5);
      expect(products.single.type, typeId);
      expect(products.single.taxes, tax.id);
      expect(products.single.order, 3);
      expect(products.single.color, '#000000');
    });

    test('updateProduct changes the product fields', () async {
      final typeId = await addBebeType();
      final tax = await getSeededTax();
      await repository.addProduct(
        name: 'Coca Cola',
        price: 2.5,
        type: typeId,
        taxes: tax.id,
        order: 3,
        color: '#000000',
      );
      final product = (await repository.getProducts()).single;

      await repository.updateProduct(
        id: product.id,
        name: 'Coca Cola Zero',
        price: 3.0,
        type: typeId,
        taxes: tax.id,
        order: 4,
        color: '#111111',
      );

      final updated = (await repository.getProducts()).single;
      expect(updated.name, 'Coca Cola Zero');
      expect(updated.price, 3.0);
      expect(updated.order, 4);
      expect(updated.color, '#111111');
    });

    test('deleteProduct removes the product', () async {
      final typeId = await addBebeType();
      final tax = await getSeededTax();
      await repository.addProduct(
        name: 'Coca Cola',
        price: 2.5,
        type: typeId,
        taxes: tax.id,
        order: 3,
        color: '#000000',
      );
      final product = (await repository.getProducts()).single;

      await repository.deleteProduct(product.id);

      expect(await repository.getProducts(), isEmpty);
    });
  });
}