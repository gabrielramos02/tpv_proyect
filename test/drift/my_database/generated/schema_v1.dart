// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class RestTables extends Table with TableInfo<RestTables, RestTablesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RestTables(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<double> top = GeneratedColumn<double>(
    'top',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> left = GeneratedColumn<double>(
    'left',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, top, left, number, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rest_tables';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestTablesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestTablesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      top: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top'],
      )!,
      left: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
    );
  }

  @override
  RestTables createAlias(String alias) {
    return RestTables(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class RestTablesData extends DataClass implements Insertable<RestTablesData> {
  final int id;
  final double top;
  final double left;
  final String number;
  final int state;
  const RestTablesData({
    required this.id,
    required this.top,
    required this.left,
    required this.number,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['top'] = Variable<double>(top);
    map['left'] = Variable<double>(left);
    map['number'] = Variable<String>(number);
    map['state'] = Variable<int>(state);
    return map;
  }

  RestTablesCompanion toCompanion(bool nullToAbsent) {
    return RestTablesCompanion(
      id: Value(id),
      top: Value(top),
      left: Value(left),
      number: Value(number),
      state: Value(state),
    );
  }

  factory RestTablesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestTablesData(
      id: serializer.fromJson<int>(json['id']),
      top: serializer.fromJson<double>(json['top']),
      left: serializer.fromJson<double>(json['left']),
      number: serializer.fromJson<String>(json['number']),
      state: serializer.fromJson<int>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'top': serializer.toJson<double>(top),
      'left': serializer.toJson<double>(left),
      'number': serializer.toJson<String>(number),
      'state': serializer.toJson<int>(state),
    };
  }

  RestTablesData copyWith({
    int? id,
    double? top,
    double? left,
    String? number,
    int? state,
  }) => RestTablesData(
    id: id ?? this.id,
    top: top ?? this.top,
    left: left ?? this.left,
    number: number ?? this.number,
    state: state ?? this.state,
  );
  RestTablesData copyWithCompanion(RestTablesCompanion data) {
    return RestTablesData(
      id: data.id.present ? data.id.value : this.id,
      top: data.top.present ? data.top.value : this.top,
      left: data.left.present ? data.left.value : this.left,
      number: data.number.present ? data.number.value : this.number,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestTablesData(')
          ..write('id: $id, ')
          ..write('top: $top, ')
          ..write('left: $left, ')
          ..write('number: $number, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, top, left, number, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestTablesData &&
          other.id == this.id &&
          other.top == this.top &&
          other.left == this.left &&
          other.number == this.number &&
          other.state == this.state);
}

class RestTablesCompanion extends UpdateCompanion<RestTablesData> {
  final Value<int> id;
  final Value<double> top;
  final Value<double> left;
  final Value<String> number;
  final Value<int> state;
  const RestTablesCompanion({
    this.id = const Value.absent(),
    this.top = const Value.absent(),
    this.left = const Value.absent(),
    this.number = const Value.absent(),
    this.state = const Value.absent(),
  });
  RestTablesCompanion.insert({
    this.id = const Value.absent(),
    required double top,
    required double left,
    required String number,
    required int state,
  }) : top = Value(top),
       left = Value(left),
       number = Value(number),
       state = Value(state);
  static Insertable<RestTablesData> custom({
    Expression<int>? id,
    Expression<double>? top,
    Expression<double>? left,
    Expression<String>? number,
    Expression<int>? state,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (top != null) 'top': top,
      if (left != null) 'left': left,
      if (number != null) 'number': number,
      if (state != null) 'state': state,
    });
  }

  RestTablesCompanion copyWith({
    Value<int>? id,
    Value<double>? top,
    Value<double>? left,
    Value<String>? number,
    Value<int>? state,
  }) {
    return RestTablesCompanion(
      id: id ?? this.id,
      top: top ?? this.top,
      left: left ?? this.left,
      number: number ?? this.number,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (top.present) {
      map['top'] = Variable<double>(top.value);
    }
    if (left.present) {
      map['left'] = Variable<double>(left.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestTablesCompanion(')
          ..write('id: $id, ')
          ..write('top: $top, ')
          ..write('left: $left, ')
          ..write('number: $number, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class ProductTypesTable extends Table
    with TableInfo<ProductTypesTable, ProductTypesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProductTypesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_types_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductTypesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductTypesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  ProductTypesTable createAlias(String alias) {
    return ProductTypesTable(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ProductTypesTableData extends DataClass
    implements Insertable<ProductTypesTableData> {
  final int id;
  final String name;
  final String color;
  final int order;
  const ProductTypesTableData({
    required this.id,
    required this.name,
    required this.color,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['order'] = Variable<int>(order);
    return map;
  }

  ProductTypesTableCompanion toCompanion(bool nullToAbsent) {
    return ProductTypesTableCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      order: Value(order),
    );
  }

  factory ProductTypesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductTypesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'order': serializer.toJson<int>(order),
    };
  }

  ProductTypesTableData copyWith({
    int? id,
    String? name,
    String? color,
    int? order,
  }) => ProductTypesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    order: order ?? this.order,
  );
  ProductTypesTableData copyWithCompanion(ProductTypesTableCompanion data) {
    return ProductTypesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductTypesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductTypesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.order == this.order);
}

class ProductTypesTableCompanion
    extends UpdateCompanion<ProductTypesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<int> order;
  const ProductTypesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.order = const Value.absent(),
  });
  ProductTypesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String color,
    required int order,
  }) : name = Value(name),
       color = Value(color),
       order = Value(order);
  static Insertable<ProductTypesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (order != null) 'order': order,
    });
  }

  ProductTypesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? color,
    Value<int>? order,
  }) {
    return ProductTypesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTypesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class Taxes extends Table with TableInfo<Taxes, TaxesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Taxes(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'taxes';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  Taxes createAlias(String alias) {
    return Taxes(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TaxesData extends DataClass implements Insertable<TaxesData> {
  final int id;
  final String name;
  final double rate;
  const TaxesData({required this.id, required this.name, required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  TaxesCompanion toCompanion(bool nullToAbsent) {
    return TaxesCompanion(id: Value(id), name: Value(name), rate: Value(rate));
  }

  factory TaxesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'rate': serializer.toJson<double>(rate),
    };
  }

  TaxesData copyWith({int? id, String? name, double? rate}) => TaxesData(
    id: id ?? this.id,
    name: name ?? this.name,
    rate: rate ?? this.rate,
  );
  TaxesData copyWithCompanion(TaxesCompanion data) {
    return TaxesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.rate == this.rate);
}

class TaxesCompanion extends UpdateCompanion<TaxesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> rate;
  const TaxesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rate = const Value.absent(),
  });
  TaxesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double rate,
  }) : name = Value(name),
       rate = Value(rate);
  static Insertable<TaxesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rate != null) 'rate': rate,
    });
  }

  TaxesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? rate,
  }) {
    return TaxesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rate: rate ?? this.rate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class ProductsClass extends Table
    with TableInfo<ProductsClass, ProductsClassData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ProductsClass(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES product_types_table(id)',
  );
  late final GeneratedColumn<int> taxes = GeneratedColumn<int>(
    'taxes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES taxes(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    price,
    color,
    order,
    type,
    taxes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_class';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsClassData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsClassData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      taxes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxes'],
      )!,
    );
  }

  @override
  ProductsClass createAlias(String alias) {
    return ProductsClass(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ProductsClassData extends DataClass
    implements Insertable<ProductsClassData> {
  final int id;
  final String name;
  final double price;
  final String color;
  final int order;
  final int type;
  final int taxes;
  const ProductsClassData({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.order,
    required this.type,
    required this.taxes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['color'] = Variable<String>(color);
    map['order'] = Variable<int>(order);
    map['type'] = Variable<int>(type);
    map['taxes'] = Variable<int>(taxes);
    return map;
  }

  ProductsClassCompanion toCompanion(bool nullToAbsent) {
    return ProductsClassCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      color: Value(color),
      order: Value(order),
      type: Value(type),
      taxes: Value(taxes),
    );
  }

  factory ProductsClassData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsClassData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      color: serializer.fromJson<String>(json['color']),
      order: serializer.fromJson<int>(json['order']),
      type: serializer.fromJson<int>(json['type']),
      taxes: serializer.fromJson<int>(json['taxes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'color': serializer.toJson<String>(color),
      'order': serializer.toJson<int>(order),
      'type': serializer.toJson<int>(type),
      'taxes': serializer.toJson<int>(taxes),
    };
  }

  ProductsClassData copyWith({
    int? id,
    String? name,
    double? price,
    String? color,
    int? order,
    int? type,
    int? taxes,
  }) => ProductsClassData(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    color: color ?? this.color,
    order: order ?? this.order,
    type: type ?? this.type,
    taxes: taxes ?? this.taxes,
  );
  ProductsClassData copyWithCompanion(ProductsClassCompanion data) {
    return ProductsClassData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      color: data.color.present ? data.color.value : this.color,
      order: data.order.present ? data.order.value : this.order,
      type: data.type.present ? data.type.value : this.type,
      taxes: data.taxes.present ? data.taxes.value : this.taxes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsClassData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('color: $color, ')
          ..write('order: $order, ')
          ..write('type: $type, ')
          ..write('taxes: $taxes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, price, color, order, type, taxes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsClassData &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.color == this.color &&
          other.order == this.order &&
          other.type == this.type &&
          other.taxes == this.taxes);
}

class ProductsClassCompanion extends UpdateCompanion<ProductsClassData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> color;
  final Value<int> order;
  final Value<int> type;
  final Value<int> taxes;
  const ProductsClassCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.color = const Value.absent(),
    this.order = const Value.absent(),
    this.type = const Value.absent(),
    this.taxes = const Value.absent(),
  });
  ProductsClassCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double price,
    required String color,
    required int order,
    required int type,
    required int taxes,
  }) : name = Value(name),
       price = Value(price),
       color = Value(color),
       order = Value(order),
       type = Value(type),
       taxes = Value(taxes);
  static Insertable<ProductsClassData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? color,
    Expression<int>? order,
    Expression<int>? type,
    Expression<int>? taxes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (color != null) 'color': color,
      if (order != null) 'order': order,
      if (type != null) 'type': type,
      if (taxes != null) 'taxes': taxes,
    });
  }

  ProductsClassCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? price,
    Value<String>? color,
    Value<int>? order,
    Value<int>? type,
    Value<int>? taxes,
  }) {
    return ProductsClassCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      color: color ?? this.color,
      order: order ?? this.order,
      type: type ?? this.type,
      taxes: taxes ?? this.taxes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (taxes.present) {
      map['taxes'] = Variable<int>(taxes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsClassCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('color: $color, ')
          ..write('order: $order, ')
          ..write('type: $type, ')
          ..write('taxes: $taxes')
          ..write(')'))
        .toString();
  }
}

class Orders extends Table with TableInfo<Orders, OrdersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Orders(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT (CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER))',
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  late final GeneratedColumn<int> closedAt = GeneratedColumn<int>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> payedPrice = GeneratedColumn<double>(
    'payed_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> totalTaxes = GeneratedColumn<double>(
    'total_taxes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> totalPriceWithTaxes =
      GeneratedColumn<double>(
        'total_price_with_taxes',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL',
      );
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> restTable = GeneratedColumn<int>(
    'rest_table',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES rest_tables(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    closedAt,
    totalPrice,
    payedPrice,
    totalTaxes,
    totalPriceWithTaxes,
    state,
    restTable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closed_at'],
      ),
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
      payedPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payed_price'],
      )!,
      totalTaxes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_taxes'],
      )!,
      totalPriceWithTaxes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price_with_taxes'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      restTable: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_table'],
      )!,
    );
  }

  @override
  Orders createAlias(String alias) {
    return Orders(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OrdersData extends DataClass implements Insertable<OrdersData> {
  final int id;
  final int createdAt;
  final int? closedAt;
  final double totalPrice;
  final double payedPrice;
  final double totalTaxes;
  final double totalPriceWithTaxes;
  final int state;
  final int restTable;
  const OrdersData({
    required this.id,
    required this.createdAt,
    this.closedAt,
    required this.totalPrice,
    required this.payedPrice,
    required this.totalTaxes,
    required this.totalPriceWithTaxes,
    required this.state,
    required this.restTable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<int>(closedAt);
    }
    map['total_price'] = Variable<double>(totalPrice);
    map['payed_price'] = Variable<double>(payedPrice);
    map['total_taxes'] = Variable<double>(totalTaxes);
    map['total_price_with_taxes'] = Variable<double>(totalPriceWithTaxes);
    map['state'] = Variable<int>(state);
    map['rest_table'] = Variable<int>(restTable);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      totalPrice: Value(totalPrice),
      payedPrice: Value(payedPrice),
      totalTaxes: Value(totalTaxes),
      totalPriceWithTaxes: Value(totalPriceWithTaxes),
      state: Value(state),
      restTable: Value(restTable),
    );
  }

  factory OrdersData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      closedAt: serializer.fromJson<int?>(json['closedAt']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      payedPrice: serializer.fromJson<double>(json['payedPrice']),
      totalTaxes: serializer.fromJson<double>(json['totalTaxes']),
      totalPriceWithTaxes: serializer.fromJson<double>(
        json['totalPriceWithTaxes'],
      ),
      state: serializer.fromJson<int>(json['state']),
      restTable: serializer.fromJson<int>(json['restTable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'closedAt': serializer.toJson<int?>(closedAt),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'payedPrice': serializer.toJson<double>(payedPrice),
      'totalTaxes': serializer.toJson<double>(totalTaxes),
      'totalPriceWithTaxes': serializer.toJson<double>(totalPriceWithTaxes),
      'state': serializer.toJson<int>(state),
      'restTable': serializer.toJson<int>(restTable),
    };
  }

  OrdersData copyWith({
    int? id,
    int? createdAt,
    Value<int?> closedAt = const Value.absent(),
    double? totalPrice,
    double? payedPrice,
    double? totalTaxes,
    double? totalPriceWithTaxes,
    int? state,
    int? restTable,
  }) => OrdersData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    totalPrice: totalPrice ?? this.totalPrice,
    payedPrice: payedPrice ?? this.payedPrice,
    totalTaxes: totalTaxes ?? this.totalTaxes,
    totalPriceWithTaxes: totalPriceWithTaxes ?? this.totalPriceWithTaxes,
    state: state ?? this.state,
    restTable: restTable ?? this.restTable,
  );
  OrdersData copyWithCompanion(OrdersCompanion data) {
    return OrdersData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      payedPrice: data.payedPrice.present
          ? data.payedPrice.value
          : this.payedPrice,
      totalTaxes: data.totalTaxes.present
          ? data.totalTaxes.value
          : this.totalTaxes,
      totalPriceWithTaxes: data.totalPriceWithTaxes.present
          ? data.totalPriceWithTaxes.value
          : this.totalPriceWithTaxes,
      state: data.state.present ? data.state.value : this.state,
      restTable: data.restTable.present ? data.restTable.value : this.restTable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('payedPrice: $payedPrice, ')
          ..write('totalTaxes: $totalTaxes, ')
          ..write('totalPriceWithTaxes: $totalPriceWithTaxes, ')
          ..write('state: $state, ')
          ..write('restTable: $restTable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    closedAt,
    totalPrice,
    payedPrice,
    totalTaxes,
    totalPriceWithTaxes,
    state,
    restTable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt &&
          other.totalPrice == this.totalPrice &&
          other.payedPrice == this.payedPrice &&
          other.totalTaxes == this.totalTaxes &&
          other.totalPriceWithTaxes == this.totalPriceWithTaxes &&
          other.state == this.state &&
          other.restTable == this.restTable);
}

class OrdersCompanion extends UpdateCompanion<OrdersData> {
  final Value<int> id;
  final Value<int> createdAt;
  final Value<int?> closedAt;
  final Value<double> totalPrice;
  final Value<double> payedPrice;
  final Value<double> totalTaxes;
  final Value<double> totalPriceWithTaxes;
  final Value<int> state;
  final Value<int> restTable;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.payedPrice = const Value.absent(),
    this.totalTaxes = const Value.absent(),
    this.totalPriceWithTaxes = const Value.absent(),
    this.state = const Value.absent(),
    this.restTable = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    required double totalPrice,
    required double payedPrice,
    required double totalTaxes,
    required double totalPriceWithTaxes,
    required int state,
    required int restTable,
  }) : totalPrice = Value(totalPrice),
       payedPrice = Value(payedPrice),
       totalTaxes = Value(totalTaxes),
       totalPriceWithTaxes = Value(totalPriceWithTaxes),
       state = Value(state),
       restTable = Value(restTable);
  static Insertable<OrdersData> custom({
    Expression<int>? id,
    Expression<int>? createdAt,
    Expression<int>? closedAt,
    Expression<double>? totalPrice,
    Expression<double>? payedPrice,
    Expression<double>? totalTaxes,
    Expression<double>? totalPriceWithTaxes,
    Expression<int>? state,
    Expression<int>? restTable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (totalPrice != null) 'total_price': totalPrice,
      if (payedPrice != null) 'payed_price': payedPrice,
      if (totalTaxes != null) 'total_taxes': totalTaxes,
      if (totalPriceWithTaxes != null)
        'total_price_with_taxes': totalPriceWithTaxes,
      if (state != null) 'state': state,
      if (restTable != null) 'rest_table': restTable,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<int>? createdAt,
    Value<int?>? closedAt,
    Value<double>? totalPrice,
    Value<double>? payedPrice,
    Value<double>? totalTaxes,
    Value<double>? totalPriceWithTaxes,
    Value<int>? state,
    Value<int>? restTable,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      totalPrice: totalPrice ?? this.totalPrice,
      payedPrice: payedPrice ?? this.payedPrice,
      totalTaxes: totalTaxes ?? this.totalTaxes,
      totalPriceWithTaxes: totalPriceWithTaxes ?? this.totalPriceWithTaxes,
      state: state ?? this.state,
      restTable: restTable ?? this.restTable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<int>(closedAt.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (payedPrice.present) {
      map['payed_price'] = Variable<double>(payedPrice.value);
    }
    if (totalTaxes.present) {
      map['total_taxes'] = Variable<double>(totalTaxes.value);
    }
    if (totalPriceWithTaxes.present) {
      map['total_price_with_taxes'] = Variable<double>(
        totalPriceWithTaxes.value,
      );
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (restTable.present) {
      map['rest_table'] = Variable<int>(restTable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('payedPrice: $payedPrice, ')
          ..write('totalTaxes: $totalTaxes, ')
          ..write('totalPriceWithTaxes: $totalPriceWithTaxes, ')
          ..write('state: $state, ')
          ..write('restTable: $restTable')
          ..write(')'))
        .toString();
  }
}

class OrderLines extends Table with TableInfo<OrderLines, OrderLinesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OrderLines(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> currentPrice = GeneratedColumn<double>(
    'current_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> taxPrice = GeneratedColumn<double>(
    'tax_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES orders(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productName,
    currentPrice,
    totalPrice,
    taxRate,
    taxPrice,
    quantity,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_lines';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLinesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLinesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      currentPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_price'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      taxPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  OrderLines createAlias(String alias) {
    return OrderLines(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OrderLinesData extends DataClass implements Insertable<OrderLinesData> {
  final int id;
  final String productName;
  final double currentPrice;
  final double totalPrice;
  final double taxRate;
  final double taxPrice;
  final int quantity;
  final int order;
  const OrderLinesData({
    required this.id,
    required this.productName,
    required this.currentPrice,
    required this.totalPrice,
    required this.taxRate,
    required this.taxPrice,
    required this.quantity,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_name'] = Variable<String>(productName);
    map['current_price'] = Variable<double>(currentPrice);
    map['total_price'] = Variable<double>(totalPrice);
    map['tax_rate'] = Variable<double>(taxRate);
    map['tax_price'] = Variable<double>(taxPrice);
    map['quantity'] = Variable<int>(quantity);
    map['order'] = Variable<int>(order);
    return map;
  }

  OrderLinesCompanion toCompanion(bool nullToAbsent) {
    return OrderLinesCompanion(
      id: Value(id),
      productName: Value(productName),
      currentPrice: Value(currentPrice),
      totalPrice: Value(totalPrice),
      taxRate: Value(taxRate),
      taxPrice: Value(taxPrice),
      quantity: Value(quantity),
      order: Value(order),
    );
  }

  factory OrderLinesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLinesData(
      id: serializer.fromJson<int>(json['id']),
      productName: serializer.fromJson<String>(json['productName']),
      currentPrice: serializer.fromJson<double>(json['currentPrice']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      taxPrice: serializer.fromJson<double>(json['taxPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productName': serializer.toJson<String>(productName),
      'currentPrice': serializer.toJson<double>(currentPrice),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'taxRate': serializer.toJson<double>(taxRate),
      'taxPrice': serializer.toJson<double>(taxPrice),
      'quantity': serializer.toJson<int>(quantity),
      'order': serializer.toJson<int>(order),
    };
  }

  OrderLinesData copyWith({
    int? id,
    String? productName,
    double? currentPrice,
    double? totalPrice,
    double? taxRate,
    double? taxPrice,
    int? quantity,
    int? order,
  }) => OrderLinesData(
    id: id ?? this.id,
    productName: productName ?? this.productName,
    currentPrice: currentPrice ?? this.currentPrice,
    totalPrice: totalPrice ?? this.totalPrice,
    taxRate: taxRate ?? this.taxRate,
    taxPrice: taxPrice ?? this.taxPrice,
    quantity: quantity ?? this.quantity,
    order: order ?? this.order,
  );
  OrderLinesData copyWithCompanion(OrderLinesCompanion data) {
    return OrderLinesData(
      id: data.id.present ? data.id.value : this.id,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      taxPrice: data.taxPrice.present ? data.taxPrice.value : this.taxPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderLinesData(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxPrice: $taxPrice, ')
          ..write('quantity: $quantity, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productName,
    currentPrice,
    totalPrice,
    taxRate,
    taxPrice,
    quantity,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLinesData &&
          other.id == this.id &&
          other.productName == this.productName &&
          other.currentPrice == this.currentPrice &&
          other.totalPrice == this.totalPrice &&
          other.taxRate == this.taxRate &&
          other.taxPrice == this.taxPrice &&
          other.quantity == this.quantity &&
          other.order == this.order);
}

class OrderLinesCompanion extends UpdateCompanion<OrderLinesData> {
  final Value<int> id;
  final Value<String> productName;
  final Value<double> currentPrice;
  final Value<double> totalPrice;
  final Value<double> taxRate;
  final Value<double> taxPrice;
  final Value<int> quantity;
  final Value<int> order;
  const OrderLinesCompanion({
    this.id = const Value.absent(),
    this.productName = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.order = const Value.absent(),
  });
  OrderLinesCompanion.insert({
    this.id = const Value.absent(),
    required String productName,
    required double currentPrice,
    required double totalPrice,
    required double taxRate,
    required double taxPrice,
    required int quantity,
    required int order,
  }) : productName = Value(productName),
       currentPrice = Value(currentPrice),
       totalPrice = Value(totalPrice),
       taxRate = Value(taxRate),
       taxPrice = Value(taxPrice),
       quantity = Value(quantity),
       order = Value(order);
  static Insertable<OrderLinesData> custom({
    Expression<int>? id,
    Expression<String>? productName,
    Expression<double>? currentPrice,
    Expression<double>? totalPrice,
    Expression<double>? taxRate,
    Expression<double>? taxPrice,
    Expression<int>? quantity,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productName != null) 'product_name': productName,
      if (currentPrice != null) 'current_price': currentPrice,
      if (totalPrice != null) 'total_price': totalPrice,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxPrice != null) 'tax_price': taxPrice,
      if (quantity != null) 'quantity': quantity,
      if (order != null) 'order': order,
    });
  }

  OrderLinesCompanion copyWith({
    Value<int>? id,
    Value<String>? productName,
    Value<double>? currentPrice,
    Value<double>? totalPrice,
    Value<double>? taxRate,
    Value<double>? taxPrice,
    Value<int>? quantity,
    Value<int>? order,
  }) {
    return OrderLinesCompanion(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      currentPrice: currentPrice ?? this.currentPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      taxRate: taxRate ?? this.taxRate,
      taxPrice: taxPrice ?? this.taxPrice,
      quantity: quantity ?? this.quantity,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<double>(currentPrice.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (taxPrice.present) {
      map['tax_price'] = Variable<double>(taxPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLinesCompanion(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxPrice: $taxPrice, ')
          ..write('quantity: $quantity, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class Payments extends Table with TableInfo<Payments, PaymentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Payments(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<double> payedAmount = GeneratedColumn<double>(
    'payed_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  late final GeneratedColumn<int> paymentDateTime = GeneratedColumn<int>(
    'payment_date_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL',
  );
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES orders(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentMethod,
    payedAmount,
    paymentDateTime,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      payedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payed_amount'],
      )!,
      paymentDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_date_time'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  Payments createAlias(String alias) {
    return Payments(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class PaymentsData extends DataClass implements Insertable<PaymentsData> {
  final int id;
  final String paymentMethod;
  final double payedAmount;
  final int? paymentDateTime;
  final int order;
  const PaymentsData({
    required this.id,
    required this.paymentMethod,
    required this.payedAmount,
    this.paymentDateTime,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payed_amount'] = Variable<double>(payedAmount);
    if (!nullToAbsent || paymentDateTime != null) {
      map['payment_date_time'] = Variable<int>(paymentDateTime);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      paymentMethod: Value(paymentMethod),
      payedAmount: Value(payedAmount),
      paymentDateTime: paymentDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDateTime),
      order: Value(order),
    );
  }

  factory PaymentsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentsData(
      id: serializer.fromJson<int>(json['id']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      payedAmount: serializer.fromJson<double>(json['payedAmount']),
      paymentDateTime: serializer.fromJson<int?>(json['paymentDateTime']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'payedAmount': serializer.toJson<double>(payedAmount),
      'paymentDateTime': serializer.toJson<int?>(paymentDateTime),
      'order': serializer.toJson<int>(order),
    };
  }

  PaymentsData copyWith({
    int? id,
    String? paymentMethod,
    double? payedAmount,
    Value<int?> paymentDateTime = const Value.absent(),
    int? order,
  }) => PaymentsData(
    id: id ?? this.id,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    payedAmount: payedAmount ?? this.payedAmount,
    paymentDateTime: paymentDateTime.present
        ? paymentDateTime.value
        : this.paymentDateTime,
    order: order ?? this.order,
  );
  PaymentsData copyWithCompanion(PaymentsCompanion data) {
    return PaymentsData(
      id: data.id.present ? data.id.value : this.id,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      payedAmount: data.payedAmount.present
          ? data.payedAmount.value
          : this.payedAmount,
      paymentDateTime: data.paymentDateTime.present
          ? data.paymentDateTime.value
          : this.paymentDateTime,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsData(')
          ..write('id: $id, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('payedAmount: $payedAmount, ')
          ..write('paymentDateTime: $paymentDateTime, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, paymentMethod, payedAmount, paymentDateTime, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentsData &&
          other.id == this.id &&
          other.paymentMethod == this.paymentMethod &&
          other.payedAmount == this.payedAmount &&
          other.paymentDateTime == this.paymentDateTime &&
          other.order == this.order);
}

class PaymentsCompanion extends UpdateCompanion<PaymentsData> {
  final Value<int> id;
  final Value<String> paymentMethod;
  final Value<double> payedAmount;
  final Value<int?> paymentDateTime;
  final Value<int> order;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.payedAmount = const Value.absent(),
    this.paymentDateTime = const Value.absent(),
    this.order = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String paymentMethod,
    required double payedAmount,
    this.paymentDateTime = const Value.absent(),
    required int order,
  }) : paymentMethod = Value(paymentMethod),
       payedAmount = Value(payedAmount),
       order = Value(order);
  static Insertable<PaymentsData> custom({
    Expression<int>? id,
    Expression<String>? paymentMethod,
    Expression<double>? payedAmount,
    Expression<int>? paymentDateTime,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (payedAmount != null) 'payed_amount': payedAmount,
      if (paymentDateTime != null) 'payment_date_time': paymentDateTime,
      if (order != null) 'order': order,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<String>? paymentMethod,
    Value<double>? payedAmount,
    Value<int?>? paymentDateTime,
    Value<int>? order,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      payedAmount: payedAmount ?? this.payedAmount,
      paymentDateTime: paymentDateTime ?? this.paymentDateTime,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (payedAmount.present) {
      map['payed_amount'] = Variable<double>(payedAmount.value);
    }
    if (paymentDateTime.present) {
      map['payment_date_time'] = Variable<int>(paymentDateTime.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('payedAmount: $payedAmount, ')
          ..write('paymentDateTime: $paymentDateTime, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final RestTables restTables = RestTables(this);
  late final ProductTypesTable productTypesTable = ProductTypesTable(this);
  late final Taxes taxes = Taxes(this);
  late final ProductsClass productsClass = ProductsClass(this);
  late final Orders orders = Orders(this);
  late final OrderLines orderLines = OrderLines(this);
  late final Payments payments = Payments(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    restTables,
    productTypesTable,
    taxes,
    productsClass,
    orders,
    orderLines,
    payments,
  ];
  @override
  int get schemaVersion => 1;
}
