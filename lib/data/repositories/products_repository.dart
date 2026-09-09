import 'package:drift/drift.dart' as drift;
import 'package:flutter_proyect/data/services/database/dbConnection.dart';

class ProductRepository {
  const ProductRepository(this._db);

  final AppDatabase _db;

  Future<List<ProductTypesTableData>> getProductTypes() {
    return _db.select(_db.productTypesTable).get();
  }

  Future<List<ProductsClassData>> getProducts() {
    return _db.select(_db.productsClass).get();
  }

  Future<void> updateProductTypeName(int id, String newName) {
    return (_db.update(_db.productTypesTable)..where((e) => e.id.isValue(id)))
        .write(ProductTypesTableCompanion(name: drift.Value(newName)));
  }

  Future<void> deleteProductType(int id) {
    return (_db.delete(
      _db.productTypesTable,
    )..where((e) => e.id.isValue(id))).go();
  }

  Future<void> addProductType(String name, int order, String color) {
    return _db
        .into(_db.productTypesTable)
        .insert(
          ProductTypesTableCompanion.insert(
            name: name,
            order: order,
            color: color,
          ),
        );
  }

  Future<List<Taxe>> getTaxes() {
    return _db.select(_db.taxes).get();
  }

  Future<void> addProduct({
    required String name,
    required double price,
    required int type,
    required int taxes,
    required int order,
    required String color,
  }) {
    return _db
        .into(_db.productsClass)
        .insert(
          ProductsClassCompanion.insert(
            name: name,
            price: price,
            type: type,
            taxes: taxes,
            order: order,
            color: color,
          ),
        );
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double price,
    required int type,
    required int taxes,
    required int order,
    required String color,
  }) {
    return (_db.update(
      _db.productsClass,
    )..where((e) => e.id.isValue(id))).write(
      ProductsClassCompanion(
        name: drift.Value(name),
        price: drift.Value(price),
        type: drift.Value(type),
        taxes: drift.Value(taxes),
        order: drift.Value(order),
        color: drift.Value(color),
      ),
    );
  }

  Future<void> deleteProduct(int id) {
    return (_db.delete(_db.productsClass)..where((e) => e.id.isValue(id))).go();
  }

  Future<Taxe> getTaxById(int id) {
    return (_db.select(
      _db.taxes,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}
