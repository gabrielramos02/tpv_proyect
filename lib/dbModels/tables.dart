import 'package:drift/drift.dart';

class RestTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get top => real()();
  RealColumn get left => real()();
  TextColumn get number => text()();
  IntColumn get state => integer()();
}

class ProductTypesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  IntColumn get order => integer()();
}

class Taxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get rate => integer()();
}

class ProductsClass extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  TextColumn get color => text()();
  IntColumn get order => integer()();
  IntColumn get type => integer().references(ProductTypesTable, #id)();
  IntColumn get taxes => integer().references(Taxes, #id)();
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  RealColumn get totalPrice => real()();
  RealColumn get payedPrice => real()();
  RealColumn get totalTaxes => real()();
  RealColumn get totalPriceWithTaxes => real()();
  IntColumn get state => integer()();
  IntColumn get taxes => integer().references(RestTables, #id)();
}
class OrderLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get productName => text()();
  RealColumn get currentPrice => real()();
  RealColumn get totalPrice => real()();
  RealColumn get taxRate => real()();
  RealColumn get taxPrice => real()();
  IntColumn get quantity => integer()();
  IntColumn get order => integer().references(Orders, #id)();
}
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get paymentMethod => text()();
  RealColumn get payedAmount => real()();
  DateTimeColumn get paymentDateTime => dateTime().nullable()();
  IntColumn get order => integer().references(Orders, #id)();
}
