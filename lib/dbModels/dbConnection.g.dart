// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbConnection.dart';

// ignore_for_file: type=lint
class $RestTablesTable extends RestTables
    with TableInfo<$RestTablesTable, RestTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _topMeta = const VerificationMeta('top');
  @override
  late final GeneratedColumn<double> top = GeneratedColumn<double>(
    'top',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leftMeta = const VerificationMeta('left');
  @override
  late final GeneratedColumn<double> left = GeneratedColumn<double>(
    'left',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, top, left, number, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rest_tables';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('top')) {
      context.handle(
        _topMeta,
        top.isAcceptableOrUnknown(data['top']!, _topMeta),
      );
    } else if (isInserting) {
      context.missing(_topMeta);
    }
    if (data.containsKey('left')) {
      context.handle(
        _leftMeta,
        left.isAcceptableOrUnknown(data['left']!, _leftMeta),
      );
    } else if (isInserting) {
      context.missing(_leftMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestTable(
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
  $RestTablesTable createAlias(String alias) {
    return $RestTablesTable(attachedDatabase, alias);
  }
}

class RestTable extends DataClass implements Insertable<RestTable> {
  final int id;
  final double top;
  final double left;
  final String number;
  final int state;
  const RestTable({
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

  factory RestTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestTable(
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

  RestTable copyWith({
    int? id,
    double? top,
    double? left,
    String? number,
    int? state,
  }) => RestTable(
    id: id ?? this.id,
    top: top ?? this.top,
    left: left ?? this.left,
    number: number ?? this.number,
    state: state ?? this.state,
  );
  RestTable copyWithCompanion(RestTablesCompanion data) {
    return RestTable(
      id: data.id.present ? data.id.value : this.id,
      top: data.top.present ? data.top.value : this.top,
      left: data.left.present ? data.left.value : this.left,
      number: data.number.present ? data.number.value : this.number,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestTable(')
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
      (other is RestTable &&
          other.id == this.id &&
          other.top == this.top &&
          other.left == this.left &&
          other.number == this.number &&
          other.state == this.state);
}

class RestTablesCompanion extends UpdateCompanion<RestTable> {
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
  static Insertable<RestTable> custom({
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

class $ProductTypesTableTable extends ProductTypesTable
    with TableInfo<$ProductTypesTableTable, ProductTypesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTypesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_types_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductTypesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

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
  $ProductTypesTableTable createAlias(String alias) {
    return $ProductTypesTableTable(attachedDatabase, alias);
  }
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

class $TaxesTable extends Taxes with TableInfo<$TaxesTable, Taxe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'taxes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Taxe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Taxe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Taxe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  $TaxesTable createAlias(String alias) {
    return $TaxesTable(attachedDatabase, alias);
  }
}

class Taxe extends DataClass implements Insertable<Taxe> {
  final int id;
  final String name;
  final int rate;
  const Taxe({required this.id, required this.name, required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['rate'] = Variable<int>(rate);
    return map;
  }

  TaxesCompanion toCompanion(bool nullToAbsent) {
    return TaxesCompanion(id: Value(id), name: Value(name), rate: Value(rate));
  }

  factory Taxe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Taxe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rate: serializer.fromJson<int>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'rate': serializer.toJson<int>(rate),
    };
  }

  Taxe copyWith({int? id, String? name, int? rate}) =>
      Taxe(id: id ?? this.id, name: name ?? this.name, rate: rate ?? this.rate);
  Taxe copyWithCompanion(TaxesCompanion data) {
    return Taxe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Taxe(')
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
      (other is Taxe &&
          other.id == this.id &&
          other.name == this.name &&
          other.rate == this.rate);
}

class TaxesCompanion extends UpdateCompanion<Taxe> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rate;
  const TaxesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rate = const Value.absent(),
  });
  TaxesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int rate,
  }) : name = Value(name),
       rate = Value(rate);
  static Insertable<Taxe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rate,
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
    Value<int>? rate,
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
      map['rate'] = Variable<int>(rate.value);
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

class $ProductsClassTable extends ProductsClass
    with TableInfo<$ProductsClassTable, ProductsClassData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsClassTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<double> color = GeneratedColumn<double>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_types_table (id)',
    ),
  );
  static const VerificationMeta _taxesMeta = const VerificationMeta('taxes');
  @override
  late final GeneratedColumn<int> taxes = GeneratedColumn<int>(
    'taxes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES taxes (id)',
    ),
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
  VerificationContext validateIntegrity(
    Insertable<ProductsClassData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('taxes')) {
      context.handle(
        _taxesMeta,
        taxes.isAcceptableOrUnknown(data['taxes']!, _taxesMeta),
      );
    } else if (isInserting) {
      context.missing(_taxesMeta);
    }
    return context;
  }

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
        DriftSqlType.double,
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
  $ProductsClassTable createAlias(String alias) {
    return $ProductsClassTable(attachedDatabase, alias);
  }
}

class ProductsClassData extends DataClass
    implements Insertable<ProductsClassData> {
  final int id;
  final String name;
  final double price;
  final double color;
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
    map['color'] = Variable<double>(color);
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
      color: serializer.fromJson<double>(json['color']),
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
      'color': serializer.toJson<double>(color),
      'order': serializer.toJson<int>(order),
      'type': serializer.toJson<int>(type),
      'taxes': serializer.toJson<int>(taxes),
    };
  }

  ProductsClassData copyWith({
    int? id,
    String? name,
    double? price,
    double? color,
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
  final Value<double> color;
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
    required double color,
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
    Expression<double>? color,
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
    Value<double>? color,
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
      map['color'] = Variable<double>(color.value);
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

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payedPriceMeta = const VerificationMeta(
    'payedPrice',
  );
  @override
  late final GeneratedColumn<double> payedPrice = GeneratedColumn<double>(
    'payed_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTaxesMeta = const VerificationMeta(
    'totalTaxes',
  );
  @override
  late final GeneratedColumn<double> totalTaxes = GeneratedColumn<double>(
    'total_taxes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceWithTaxesMeta =
      const VerificationMeta('totalPriceWithTaxes');
  @override
  late final GeneratedColumn<double> totalPriceWithTaxes =
      GeneratedColumn<double>(
        'total_price_with_taxes',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxesMeta = const VerificationMeta('taxes');
  @override
  late final GeneratedColumn<int> taxes = GeneratedColumn<int>(
    'taxes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rest_tables (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    closedAt,
    totalPrice,
    payedPrice,
    totalTaxes,
    totalPriceWithTaxes,
    state,
    taxes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('payed_price')) {
      context.handle(
        _payedPriceMeta,
        payedPrice.isAcceptableOrUnknown(data['payed_price']!, _payedPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_payedPriceMeta);
    }
    if (data.containsKey('total_taxes')) {
      context.handle(
        _totalTaxesMeta,
        totalTaxes.isAcceptableOrUnknown(data['total_taxes']!, _totalTaxesMeta),
      );
    } else if (isInserting) {
      context.missing(_totalTaxesMeta);
    }
    if (data.containsKey('total_price_with_taxes')) {
      context.handle(
        _totalPriceWithTaxesMeta,
        totalPriceWithTaxes.isAcceptableOrUnknown(
          data['total_price_with_taxes']!,
          _totalPriceWithTaxesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPriceWithTaxesMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('taxes')) {
      context.handle(
        _taxesMeta,
        taxes.isAcceptableOrUnknown(data['taxes']!, _taxesMeta),
      );
    } else if (isInserting) {
      context.missing(_taxesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
      taxes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxes'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? closedAt;
  final double totalPrice;
  final double payedPrice;
  final double totalTaxes;
  final double totalPriceWithTaxes;
  final int state;
  final int taxes;
  const Order({
    required this.id,
    required this.name,
    this.createdAt,
    this.closedAt,
    required this.totalPrice,
    required this.payedPrice,
    required this.totalTaxes,
    required this.totalPriceWithTaxes,
    required this.state,
    required this.taxes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['total_price'] = Variable<double>(totalPrice);
    map['payed_price'] = Variable<double>(payedPrice);
    map['total_taxes'] = Variable<double>(totalTaxes);
    map['total_price_with_taxes'] = Variable<double>(totalPriceWithTaxes);
    map['state'] = Variable<int>(state);
    map['taxes'] = Variable<int>(taxes);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      totalPrice: Value(totalPrice),
      payedPrice: Value(payedPrice),
      totalTaxes: Value(totalTaxes),
      totalPriceWithTaxes: Value(totalPriceWithTaxes),
      state: Value(state),
      taxes: Value(taxes),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      payedPrice: serializer.fromJson<double>(json['payedPrice']),
      totalTaxes: serializer.fromJson<double>(json['totalTaxes']),
      totalPriceWithTaxes: serializer.fromJson<double>(
        json['totalPriceWithTaxes'],
      ),
      state: serializer.fromJson<int>(json['state']),
      taxes: serializer.fromJson<int>(json['taxes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'payedPrice': serializer.toJson<double>(payedPrice),
      'totalTaxes': serializer.toJson<double>(totalTaxes),
      'totalPriceWithTaxes': serializer.toJson<double>(totalPriceWithTaxes),
      'state': serializer.toJson<int>(state),
      'taxes': serializer.toJson<int>(taxes),
    };
  }

  Order copyWith({
    int? id,
    String? name,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> closedAt = const Value.absent(),
    double? totalPrice,
    double? payedPrice,
    double? totalTaxes,
    double? totalPriceWithTaxes,
    int? state,
    int? taxes,
  }) => Order(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    totalPrice: totalPrice ?? this.totalPrice,
    payedPrice: payedPrice ?? this.payedPrice,
    totalTaxes: totalTaxes ?? this.totalTaxes,
    totalPriceWithTaxes: totalPriceWithTaxes ?? this.totalPriceWithTaxes,
    state: state ?? this.state,
    taxes: taxes ?? this.taxes,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
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
      taxes: data.taxes.present ? data.taxes.value : this.taxes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('payedPrice: $payedPrice, ')
          ..write('totalTaxes: $totalTaxes, ')
          ..write('totalPriceWithTaxes: $totalPriceWithTaxes, ')
          ..write('state: $state, ')
          ..write('taxes: $taxes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    closedAt,
    totalPrice,
    payedPrice,
    totalTaxes,
    totalPriceWithTaxes,
    state,
    taxes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt &&
          other.totalPrice == this.totalPrice &&
          other.payedPrice == this.payedPrice &&
          other.totalTaxes == this.totalTaxes &&
          other.totalPriceWithTaxes == this.totalPriceWithTaxes &&
          other.state == this.state &&
          other.taxes == this.taxes);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> closedAt;
  final Value<double> totalPrice;
  final Value<double> payedPrice;
  final Value<double> totalTaxes;
  final Value<double> totalPriceWithTaxes;
  final Value<int> state;
  final Value<int> taxes;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.payedPrice = const Value.absent(),
    this.totalTaxes = const Value.absent(),
    this.totalPriceWithTaxes = const Value.absent(),
    this.state = const Value.absent(),
    this.taxes = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    required double totalPrice,
    required double payedPrice,
    required double totalTaxes,
    required double totalPriceWithTaxes,
    required int state,
    required int taxes,
  }) : name = Value(name),
       totalPrice = Value(totalPrice),
       payedPrice = Value(payedPrice),
       totalTaxes = Value(totalTaxes),
       totalPriceWithTaxes = Value(totalPriceWithTaxes),
       state = Value(state),
       taxes = Value(taxes);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? closedAt,
    Expression<double>? totalPrice,
    Expression<double>? payedPrice,
    Expression<double>? totalTaxes,
    Expression<double>? totalPriceWithTaxes,
    Expression<int>? state,
    Expression<int>? taxes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (totalPrice != null) 'total_price': totalPrice,
      if (payedPrice != null) 'payed_price': payedPrice,
      if (totalTaxes != null) 'total_taxes': totalTaxes,
      if (totalPriceWithTaxes != null)
        'total_price_with_taxes': totalPriceWithTaxes,
      if (state != null) 'state': state,
      if (taxes != null) 'taxes': taxes,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? closedAt,
    Value<double>? totalPrice,
    Value<double>? payedPrice,
    Value<double>? totalTaxes,
    Value<double>? totalPriceWithTaxes,
    Value<int>? state,
    Value<int>? taxes,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
      totalPrice: totalPrice ?? this.totalPrice,
      payedPrice: payedPrice ?? this.payedPrice,
      totalTaxes: totalTaxes ?? this.totalTaxes,
      totalPriceWithTaxes: totalPriceWithTaxes ?? this.totalPriceWithTaxes,
      state: state ?? this.state,
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
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
    if (taxes.present) {
      map['taxes'] = Variable<int>(taxes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('payedPrice: $payedPrice, ')
          ..write('totalTaxes: $totalTaxes, ')
          ..write('totalPriceWithTaxes: $totalPriceWithTaxes, ')
          ..write('state: $state, ')
          ..write('taxes: $taxes')
          ..write(')'))
        .toString();
  }
}

class $OrderLinesTable extends OrderLines
    with TableInfo<$OrderLinesTable, OrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPriceMeta = const VerificationMeta(
    'currentPrice',
  );
  @override
  late final GeneratedColumn<double> currentPrice = GeneratedColumn<double>(
    'current_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxPriceMeta = const VerificationMeta(
    'taxPrice',
  );
  @override
  late final GeneratedColumn<double> taxPrice = GeneratedColumn<double>(
    'tax_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
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
  VerificationContext validateIntegrity(
    Insertable<OrderLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('current_price')) {
      context.handle(
        _currentPriceMeta,
        currentPrice.isAcceptableOrUnknown(
          data['current_price']!,
          _currentPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentPriceMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    if (data.containsKey('tax_price')) {
      context.handle(
        _taxPriceMeta,
        taxPrice.isAcceptableOrUnknown(data['tax_price']!, _taxPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_taxPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
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
  $OrderLinesTable createAlias(String alias) {
    return $OrderLinesTable(attachedDatabase, alias);
  }
}

class OrderLine extends DataClass implements Insertable<OrderLine> {
  final int id;
  final String name;
  final String productName;
  final double currentPrice;
  final double totalPrice;
  final double taxRate;
  final double taxPrice;
  final int quantity;
  final int order;
  const OrderLine({
    required this.id,
    required this.name,
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
    map['name'] = Variable<String>(name);
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
      name: Value(name),
      productName: Value(productName),
      currentPrice: Value(currentPrice),
      totalPrice: Value(totalPrice),
      taxRate: Value(taxRate),
      taxPrice: Value(taxPrice),
      quantity: Value(quantity),
      order: Value(order),
    );
  }

  factory OrderLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
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
      'name': serializer.toJson<String>(name),
      'productName': serializer.toJson<String>(productName),
      'currentPrice': serializer.toJson<double>(currentPrice),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'taxRate': serializer.toJson<double>(taxRate),
      'taxPrice': serializer.toJson<double>(taxPrice),
      'quantity': serializer.toJson<int>(quantity),
      'order': serializer.toJson<int>(order),
    };
  }

  OrderLine copyWith({
    int? id,
    String? name,
    String? productName,
    double? currentPrice,
    double? totalPrice,
    double? taxRate,
    double? taxPrice,
    int? quantity,
    int? order,
  }) => OrderLine(
    id: id ?? this.id,
    name: name ?? this.name,
    productName: productName ?? this.productName,
    currentPrice: currentPrice ?? this.currentPrice,
    totalPrice: totalPrice ?? this.totalPrice,
    taxRate: taxRate ?? this.taxRate,
    taxPrice: taxPrice ?? this.taxPrice,
    quantity: quantity ?? this.quantity,
    order: order ?? this.order,
  );
  OrderLine copyWithCompanion(OrderLinesCompanion data) {
    return OrderLine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
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
    return (StringBuffer('OrderLine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
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
    name,
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
      (other is OrderLine &&
          other.id == this.id &&
          other.name == this.name &&
          other.productName == this.productName &&
          other.currentPrice == this.currentPrice &&
          other.totalPrice == this.totalPrice &&
          other.taxRate == this.taxRate &&
          other.taxPrice == this.taxPrice &&
          other.quantity == this.quantity &&
          other.order == this.order);
}

class OrderLinesCompanion extends UpdateCompanion<OrderLine> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> productName;
  final Value<double> currentPrice;
  final Value<double> totalPrice;
  final Value<double> taxRate;
  final Value<double> taxPrice;
  final Value<int> quantity;
  final Value<int> order;
  const OrderLinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
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
    required String name,
    required String productName,
    required double currentPrice,
    required double totalPrice,
    required double taxRate,
    required double taxPrice,
    required int quantity,
    required int order,
  }) : name = Value(name),
       productName = Value(productName),
       currentPrice = Value(currentPrice),
       totalPrice = Value(totalPrice),
       taxRate = Value(taxRate),
       taxPrice = Value(taxPrice),
       quantity = Value(quantity),
       order = Value(order);
  static Insertable<OrderLine> custom({
    Expression<int>? id,
    Expression<String>? name,
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
      if (name != null) 'name': name,
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
    Value<String>? name,
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
      name: name ?? this.name,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
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
          ..write('name: $name, ')
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

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payedAmountMeta = const VerificationMeta(
    'payedAmount',
  );
  @override
  late final GeneratedColumn<double> payedAmount = GeneratedColumn<double>(
    'payed_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentDateTimeMeta = const VerificationMeta(
    'paymentDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDateTime =
      GeneratedColumn<DateTime>(
        'payment_date_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
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
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('payed_amount')) {
      context.handle(
        _payedAmountMeta,
        payedAmount.isAcceptableOrUnknown(
          data['payed_amount']!,
          _payedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payedAmountMeta);
    }
    if (data.containsKey('payment_date_time')) {
      context.handle(
        _paymentDateTimeMeta,
        paymentDateTime.isAcceptableOrUnknown(
          data['payment_date_time']!,
          _paymentDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date_time'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final String paymentMethod;
  final double payedAmount;
  final DateTime? paymentDateTime;
  final int order;
  const Payment({
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
      map['payment_date_time'] = Variable<DateTime>(paymentDateTime);
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

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      payedAmount: serializer.fromJson<double>(json['payedAmount']),
      paymentDateTime: serializer.fromJson<DateTime?>(json['paymentDateTime']),
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
      'paymentDateTime': serializer.toJson<DateTime?>(paymentDateTime),
      'order': serializer.toJson<int>(order),
    };
  }

  Payment copyWith({
    int? id,
    String? paymentMethod,
    double? payedAmount,
    Value<DateTime?> paymentDateTime = const Value.absent(),
    int? order,
  }) => Payment(
    id: id ?? this.id,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    payedAmount: payedAmount ?? this.payedAmount,
    paymentDateTime: paymentDateTime.present
        ? paymentDateTime.value
        : this.paymentDateTime,
    order: order ?? this.order,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
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
    return (StringBuffer('Payment(')
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
      (other is Payment &&
          other.id == this.id &&
          other.paymentMethod == this.paymentMethod &&
          other.payedAmount == this.payedAmount &&
          other.paymentDateTime == this.paymentDateTime &&
          other.order == this.order);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<String> paymentMethod;
  final Value<double> payedAmount;
  final Value<DateTime?> paymentDateTime;
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
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<String>? paymentMethod,
    Expression<double>? payedAmount,
    Expression<DateTime>? paymentDateTime,
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
    Value<DateTime?>? paymentDateTime,
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
      map['payment_date_time'] = Variable<DateTime>(paymentDateTime.value);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RestTablesTable restTables = $RestTablesTable(this);
  late final $ProductTypesTableTable productTypesTable =
      $ProductTypesTableTable(this);
  late final $TaxesTable taxes = $TaxesTable(this);
  late final $ProductsClassTable productsClass = $ProductsClassTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderLinesTable orderLines = $OrderLinesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
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
}

typedef $$RestTablesTableCreateCompanionBuilder =
    RestTablesCompanion Function({
      Value<int> id,
      required double top,
      required double left,
      required String number,
      required int state,
    });
typedef $$RestTablesTableUpdateCompanionBuilder =
    RestTablesCompanion Function({
      Value<int> id,
      Value<double> top,
      Value<double> left,
      Value<String> number,
      Value<int> state,
    });

final class $$RestTablesTableReferences
    extends BaseReferences<_$AppDatabase, $RestTablesTable, RestTable> {
  $$RestTablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.restTables.id, db.orders.taxes),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.taxes.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RestTablesTableFilterComposer
    extends Composer<_$AppDatabase, $RestTablesTable> {
  $$RestTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get top => $composableBuilder(
    column: $table.top,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.taxes,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RestTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestTablesTable> {
  $$RestTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get top => $composableBuilder(
    column: $table.top,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestTablesTable> {
  $$RestTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get top =>
      $composableBuilder(column: $table.top, builder: (column) => column);

  GeneratedColumn<double> get left =>
      $composableBuilder(column: $table.left, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.taxes,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RestTablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestTablesTable,
          RestTable,
          $$RestTablesTableFilterComposer,
          $$RestTablesTableOrderingComposer,
          $$RestTablesTableAnnotationComposer,
          $$RestTablesTableCreateCompanionBuilder,
          $$RestTablesTableUpdateCompanionBuilder,
          (RestTable, $$RestTablesTableReferences),
          RestTable,
          PrefetchHooks Function({bool ordersRefs})
        > {
  $$RestTablesTableTableManager(_$AppDatabase db, $RestTablesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> top = const Value.absent(),
                Value<double> left = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<int> state = const Value.absent(),
              }) => RestTablesCompanion(
                id: id,
                top: top,
                left: left,
                number: number,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double top,
                required double left,
                required String number,
                required int state,
              }) => RestTablesCompanion.insert(
                id: id,
                top: top,
                left: left,
                number: number,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RestTablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<
                      RestTable,
                      $RestTablesTable,
                      Order
                    >(
                      currentTable: table,
                      referencedTable: $$RestTablesTableReferences
                          ._ordersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RestTablesTableReferences(db, table, p0).ordersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taxes == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RestTablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestTablesTable,
      RestTable,
      $$RestTablesTableFilterComposer,
      $$RestTablesTableOrderingComposer,
      $$RestTablesTableAnnotationComposer,
      $$RestTablesTableCreateCompanionBuilder,
      $$RestTablesTableUpdateCompanionBuilder,
      (RestTable, $$RestTablesTableReferences),
      RestTable,
      PrefetchHooks Function({bool ordersRefs})
    >;
typedef $$ProductTypesTableTableCreateCompanionBuilder =
    ProductTypesTableCompanion Function({
      Value<int> id,
      required String name,
      required String color,
      required int order,
    });
typedef $$ProductTypesTableTableUpdateCompanionBuilder =
    ProductTypesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> color,
      Value<int> order,
    });

final class $$ProductTypesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductTypesTableTable,
          ProductTypesTableData
        > {
  $$ProductTypesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ProductsClassTable, List<ProductsClassData>>
  _productsClassRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productsClass,
    aliasName: $_aliasNameGenerator(
      db.productTypesTable.id,
      db.productsClass.type,
    ),
  );

  $$ProductsClassTableProcessedTableManager get productsClassRefs {
    final manager = $$ProductsClassTableTableManager(
      $_db,
      $_db.productsClass,
    ).filter((f) => f.type.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsClassRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductTypesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductTypesTableTable> {
  $$ProductTypesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsClassRefs(
    Expression<bool> Function($$ProductsClassTableFilterComposer f) f,
  ) {
    final $$ProductsClassTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsClass,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsClassTableFilterComposer(
            $db: $db,
            $table: $db.productsClass,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductTypesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductTypesTableTable> {
  $$ProductTypesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductTypesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductTypesTableTable> {
  $$ProductTypesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  Expression<T> productsClassRefs<T extends Object>(
    Expression<T> Function($$ProductsClassTableAnnotationComposer a) f,
  ) {
    final $$ProductsClassTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsClass,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsClassTableAnnotationComposer(
            $db: $db,
            $table: $db.productsClass,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductTypesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductTypesTableTable,
          ProductTypesTableData,
          $$ProductTypesTableTableFilterComposer,
          $$ProductTypesTableTableOrderingComposer,
          $$ProductTypesTableTableAnnotationComposer,
          $$ProductTypesTableTableCreateCompanionBuilder,
          $$ProductTypesTableTableUpdateCompanionBuilder,
          (ProductTypesTableData, $$ProductTypesTableTableReferences),
          ProductTypesTableData,
          PrefetchHooks Function({bool productsClassRefs})
        > {
  $$ProductTypesTableTableTableManager(
    _$AppDatabase db,
    $ProductTypesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTypesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTypesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductTypesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => ProductTypesTableCompanion(
                id: id,
                name: name,
                color: color,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String color,
                required int order,
              }) => ProductTypesTableCompanion.insert(
                id: id,
                name: name,
                color: color,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductTypesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsClassRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsClassRefs) db.productsClass,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsClassRefs)
                    await $_getPrefetchedData<
                      ProductTypesTableData,
                      $ProductTypesTableTable,
                      ProductsClassData
                    >(
                      currentTable: table,
                      referencedTable: $$ProductTypesTableTableReferences
                          ._productsClassRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProductTypesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).productsClassRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.type == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductTypesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductTypesTableTable,
      ProductTypesTableData,
      $$ProductTypesTableTableFilterComposer,
      $$ProductTypesTableTableOrderingComposer,
      $$ProductTypesTableTableAnnotationComposer,
      $$ProductTypesTableTableCreateCompanionBuilder,
      $$ProductTypesTableTableUpdateCompanionBuilder,
      (ProductTypesTableData, $$ProductTypesTableTableReferences),
      ProductTypesTableData,
      PrefetchHooks Function({bool productsClassRefs})
    >;
typedef $$TaxesTableCreateCompanionBuilder =
    TaxesCompanion Function({
      Value<int> id,
      required String name,
      required int rate,
    });
typedef $$TaxesTableUpdateCompanionBuilder =
    TaxesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> rate,
    });

final class $$TaxesTableReferences
    extends BaseReferences<_$AppDatabase, $TaxesTable, Taxe> {
  $$TaxesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsClassTable, List<ProductsClassData>>
  _productsClassRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productsClass,
    aliasName: $_aliasNameGenerator(db.taxes.id, db.productsClass.taxes),
  );

  $$ProductsClassTableProcessedTableManager get productsClassRefs {
    final manager = $$ProductsClassTableTableManager(
      $_db,
      $_db.productsClass,
    ).filter((f) => f.taxes.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsClassRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaxesTableFilterComposer extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsClassRefs(
    Expression<bool> Function($$ProductsClassTableFilterComposer f) f,
  ) {
    final $$ProductsClassTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsClass,
      getReferencedColumn: (t) => t.taxes,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsClassTableFilterComposer(
            $db: $db,
            $table: $db.productsClass,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxesTable> {
  $$TaxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  Expression<T> productsClassRefs<T extends Object>(
    Expression<T> Function($$ProductsClassTableAnnotationComposer a) f,
  ) {
    final $$ProductsClassTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productsClass,
      getReferencedColumn: (t) => t.taxes,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsClassTableAnnotationComposer(
            $db: $db,
            $table: $db.productsClass,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaxesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaxesTable,
          Taxe,
          $$TaxesTableFilterComposer,
          $$TaxesTableOrderingComposer,
          $$TaxesTableAnnotationComposer,
          $$TaxesTableCreateCompanionBuilder,
          $$TaxesTableUpdateCompanionBuilder,
          (Taxe, $$TaxesTableReferences),
          Taxe,
          PrefetchHooks Function({bool productsClassRefs})
        > {
  $$TaxesTableTableManager(_$AppDatabase db, $TaxesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rate = const Value.absent(),
              }) => TaxesCompanion(id: id, name: name, rate: rate),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int rate,
              }) => TaxesCompanion.insert(id: id, name: name, rate: rate),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TaxesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({productsClassRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productsClassRefs) db.productsClass,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsClassRefs)
                    await $_getPrefetchedData<
                      Taxe,
                      $TaxesTable,
                      ProductsClassData
                    >(
                      currentTable: table,
                      referencedTable: $$TaxesTableReferences
                          ._productsClassRefsTable(db),
                      managerFromTypedResult: (p0) => $$TaxesTableReferences(
                        db,
                        table,
                        p0,
                      ).productsClassRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taxes == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaxesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaxesTable,
      Taxe,
      $$TaxesTableFilterComposer,
      $$TaxesTableOrderingComposer,
      $$TaxesTableAnnotationComposer,
      $$TaxesTableCreateCompanionBuilder,
      $$TaxesTableUpdateCompanionBuilder,
      (Taxe, $$TaxesTableReferences),
      Taxe,
      PrefetchHooks Function({bool productsClassRefs})
    >;
typedef $$ProductsClassTableCreateCompanionBuilder =
    ProductsClassCompanion Function({
      Value<int> id,
      required String name,
      required double price,
      required double color,
      required int order,
      required int type,
      required int taxes,
    });
typedef $$ProductsClassTableUpdateCompanionBuilder =
    ProductsClassCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> price,
      Value<double> color,
      Value<int> order,
      Value<int> type,
      Value<int> taxes,
    });

final class $$ProductsClassTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductsClassTable, ProductsClassData> {
  $$ProductsClassTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductTypesTableTable _typeTable(_$AppDatabase db) =>
      db.productTypesTable.createAlias(
        $_aliasNameGenerator(db.productsClass.type, db.productTypesTable.id),
      );

  $$ProductTypesTableTableProcessedTableManager get type {
    final $_column = $_itemColumn<int>('type')!;

    final manager = $$ProductTypesTableTableTableManager(
      $_db,
      $_db.productTypesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaxesTable _taxesTable(_$AppDatabase db) => db.taxes.createAlias(
    $_aliasNameGenerator(db.productsClass.taxes, db.taxes.id),
  );

  $$TaxesTableProcessedTableManager get taxes {
    final $_column = $_itemColumn<int>('taxes')!;

    final manager = $$TaxesTableTableManager(
      $_db,
      $_db.taxes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxesTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductsClassTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsClassTable> {
  $$ProductsClassTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductTypesTableTableFilterComposer get type {
    final $$ProductTypesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.productTypesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTypesTableTableFilterComposer(
            $db: $db,
            $table: $db.productTypesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxesTableFilterComposer get taxes {
    final $$TaxesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.taxes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxesTableFilterComposer(
            $db: $db,
            $table: $db.taxes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsClassTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsClassTable> {
  $$ProductsClassTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductTypesTableTableOrderingComposer get type {
    final $$ProductTypesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.productTypesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductTypesTableTableOrderingComposer(
            $db: $db,
            $table: $db.productTypesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaxesTableOrderingComposer get taxes {
    final $$TaxesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.taxes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxesTableOrderingComposer(
            $db: $db,
            $table: $db.taxes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsClassTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsClassTable> {
  $$ProductsClassTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$ProductTypesTableTableAnnotationComposer get type {
    final $$ProductTypesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.type,
          referencedTable: $db.productTypesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductTypesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.productTypesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TaxesTableAnnotationComposer get taxes {
    final $$TaxesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.taxes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaxesTableAnnotationComposer(
            $db: $db,
            $table: $db.taxes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsClassTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsClassTable,
          ProductsClassData,
          $$ProductsClassTableFilterComposer,
          $$ProductsClassTableOrderingComposer,
          $$ProductsClassTableAnnotationComposer,
          $$ProductsClassTableCreateCompanionBuilder,
          $$ProductsClassTableUpdateCompanionBuilder,
          (ProductsClassData, $$ProductsClassTableReferences),
          ProductsClassData,
          PrefetchHooks Function({bool type, bool taxes})
        > {
  $$ProductsClassTableTableManager(_$AppDatabase db, $ProductsClassTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsClassTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsClassTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsClassTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> color = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> taxes = const Value.absent(),
              }) => ProductsClassCompanion(
                id: id,
                name: name,
                price: price,
                color: color,
                order: order,
                type: type,
                taxes: taxes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double price,
                required double color,
                required int order,
                required int type,
                required int taxes,
              }) => ProductsClassCompanion.insert(
                id: id,
                name: name,
                price: price,
                color: color,
                order: order,
                type: type,
                taxes: taxes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsClassTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({type = false, taxes = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (type) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.type,
                                referencedTable: $$ProductsClassTableReferences
                                    ._typeTable(db),
                                referencedColumn: $$ProductsClassTableReferences
                                    ._typeTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (taxes) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taxes,
                                referencedTable: $$ProductsClassTableReferences
                                    ._taxesTable(db),
                                referencedColumn: $$ProductsClassTableReferences
                                    ._taxesTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductsClassTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsClassTable,
      ProductsClassData,
      $$ProductsClassTableFilterComposer,
      $$ProductsClassTableOrderingComposer,
      $$ProductsClassTableAnnotationComposer,
      $$ProductsClassTableCreateCompanionBuilder,
      $$ProductsClassTableUpdateCompanionBuilder,
      (ProductsClassData, $$ProductsClassTableReferences),
      ProductsClassData,
      PrefetchHooks Function({bool type, bool taxes})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime?> createdAt,
      Value<DateTime?> closedAt,
      required double totalPrice,
      required double payedPrice,
      required double totalTaxes,
      required double totalPriceWithTaxes,
      required int state,
      required int taxes,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> createdAt,
      Value<DateTime?> closedAt,
      Value<double> totalPrice,
      Value<double> payedPrice,
      Value<double> totalTaxes,
      Value<double> totalPriceWithTaxes,
      Value<int> state,
      Value<int> taxes,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RestTablesTable _taxesTable(_$AppDatabase db) => db.restTables
      .createAlias($_aliasNameGenerator(db.orders.taxes, db.restTables.id));

  $$RestTablesTableProcessedTableManager get taxes {
    final $_column = $_itemColumn<int>('taxes')!;

    final manager = $$RestTablesTableTableManager(
      $_db,
      $_db.restTables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxesTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderLinesTable, List<OrderLine>>
  _orderLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLines,
    aliasName: $_aliasNameGenerator(db.orders.id, db.orderLines.order),
  );

  $$OrderLinesTableProcessedTableManager get orderLinesRefs {
    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.order.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.orders.id, db.payments.order),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.order.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payedPrice => $composableBuilder(
    column: $table.payedPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalTaxes => $composableBuilder(
    column: $table.totalTaxes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPriceWithTaxes => $composableBuilder(
    column: $table.totalPriceWithTaxes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  $$RestTablesTableFilterComposer get taxes {
    final $$RestTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.restTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestTablesTableFilterComposer(
            $db: $db,
            $table: $db.restTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderLinesRefs(
    Expression<bool> Function($$OrderLinesTableFilterComposer f) f,
  ) {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.order,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.order,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payedPrice => $composableBuilder(
    column: $table.payedPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalTaxes => $composableBuilder(
    column: $table.totalTaxes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPriceWithTaxes => $composableBuilder(
    column: $table.totalPriceWithTaxes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  $$RestTablesTableOrderingComposer get taxes {
    final $$RestTablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.restTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestTablesTableOrderingComposer(
            $db: $db,
            $table: $db.restTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payedPrice => $composableBuilder(
    column: $table.payedPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalTaxes => $composableBuilder(
    column: $table.totalTaxes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPriceWithTaxes => $composableBuilder(
    column: $table.totalPriceWithTaxes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  $$RestTablesTableAnnotationComposer get taxes {
    final $$RestTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taxes,
      referencedTable: $db.restTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RestTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.restTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderLinesRefs<T extends Object>(
    Expression<T> Function($$OrderLinesTableAnnotationComposer a) f,
  ) {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.order,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.order,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool taxes,
            bool orderLinesRefs,
            bool paymentsRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<double> payedPrice = const Value.absent(),
                Value<double> totalTaxes = const Value.absent(),
                Value<double> totalPriceWithTaxes = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> taxes = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                closedAt: closedAt,
                totalPrice: totalPrice,
                payedPrice: payedPrice,
                totalTaxes: totalTaxes,
                totalPriceWithTaxes: totalPriceWithTaxes,
                state: state,
                taxes: taxes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                required double totalPrice,
                required double payedPrice,
                required double totalTaxes,
                required double totalPriceWithTaxes,
                required int state,
                required int taxes,
              }) => OrdersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                closedAt: closedAt,
                totalPrice: totalPrice,
                payedPrice: payedPrice,
                totalTaxes: totalTaxes,
                totalPriceWithTaxes: totalPriceWithTaxes,
                state: state,
                taxes: taxes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({taxes = false, orderLinesRefs = false, paymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderLinesRefs) db.orderLines,
                    if (paymentsRefs) db.payments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (taxes) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taxes,
                                    referencedTable: $$OrdersTableReferences
                                        ._taxesTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._taxesTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderLinesRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderLine
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.order == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<Order, $OrdersTable, Payment>(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.order == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool taxes,
        bool orderLinesRefs,
        bool paymentsRefs,
      })
    >;
typedef $$OrderLinesTableCreateCompanionBuilder =
    OrderLinesCompanion Function({
      Value<int> id,
      required String name,
      required String productName,
      required double currentPrice,
      required double totalPrice,
      required double taxRate,
      required double taxPrice,
      required int quantity,
      required int order,
    });
typedef $$OrderLinesTableUpdateCompanionBuilder =
    OrderLinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> productName,
      Value<double> currentPrice,
      Value<double> totalPrice,
      Value<double> taxRate,
      Value<double> taxPrice,
      Value<int> quantity,
      Value<int> order,
    });

final class $$OrderLinesTableReferences
    extends BaseReferences<_$AppDatabase, $OrderLinesTable, OrderLine> {
  $$OrderLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderLines.order, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get order {
    final $_column = $_itemColumn<int>('order')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderLinesTableFilterComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxPrice => $composableBuilder(
    column: $table.taxPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get order {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxPrice => $composableBuilder(
    column: $table.taxPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get order {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentPrice => $composableBuilder(
    column: $table.currentPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get taxPrice =>
      $composableBuilder(column: $table.taxPrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$OrdersTableAnnotationComposer get order {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderLinesTable,
          OrderLine,
          $$OrderLinesTableFilterComposer,
          $$OrderLinesTableOrderingComposer,
          $$OrderLinesTableAnnotationComposer,
          $$OrderLinesTableCreateCompanionBuilder,
          $$OrderLinesTableUpdateCompanionBuilder,
          (OrderLine, $$OrderLinesTableReferences),
          OrderLine,
          PrefetchHooks Function({bool order})
        > {
  $$OrderLinesTableTableManager(_$AppDatabase db, $OrderLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> currentPrice = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> taxPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => OrderLinesCompanion(
                id: id,
                name: name,
                productName: productName,
                currentPrice: currentPrice,
                totalPrice: totalPrice,
                taxRate: taxRate,
                taxPrice: taxPrice,
                quantity: quantity,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String productName,
                required double currentPrice,
                required double totalPrice,
                required double taxRate,
                required double taxPrice,
                required int quantity,
                required int order,
              }) => OrderLinesCompanion.insert(
                id: id,
                name: name,
                productName: productName,
                currentPrice: currentPrice,
                totalPrice: totalPrice,
                taxRate: taxRate,
                taxPrice: taxPrice,
                quantity: quantity,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({order = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (order) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.order,
                                referencedTable: $$OrderLinesTableReferences
                                    ._orderTable(db),
                                referencedColumn: $$OrderLinesTableReferences
                                    ._orderTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderLinesTable,
      OrderLine,
      $$OrderLinesTableFilterComposer,
      $$OrderLinesTableOrderingComposer,
      $$OrderLinesTableAnnotationComposer,
      $$OrderLinesTableCreateCompanionBuilder,
      $$OrderLinesTableUpdateCompanionBuilder,
      (OrderLine, $$OrderLinesTableReferences),
      OrderLine,
      PrefetchHooks Function({bool order})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required String paymentMethod,
      required double payedAmount,
      Value<DateTime?> paymentDateTime,
      required int order,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<String> paymentMethod,
      Value<double> payedAmount,
      Value<DateTime?> paymentDateTime,
      Value<int> order,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.payments.order, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get order {
    final $_column = $_itemColumn<int>('order')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payedAmount => $composableBuilder(
    column: $table.payedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDateTime => $composableBuilder(
    column: $table.paymentDateTime,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get order {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payedAmount => $composableBuilder(
    column: $table.payedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDateTime => $composableBuilder(
    column: $table.paymentDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get order {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payedAmount => $composableBuilder(
    column: $table.payedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDateTime => $composableBuilder(
    column: $table.paymentDateTime,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get order {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.order,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool order})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double> payedAmount = const Value.absent(),
                Value<DateTime?> paymentDateTime = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                paymentMethod: paymentMethod,
                payedAmount: payedAmount,
                paymentDateTime: paymentDateTime,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String paymentMethod,
                required double payedAmount,
                Value<DateTime?> paymentDateTime = const Value.absent(),
                required int order,
              }) => PaymentsCompanion.insert(
                id: id,
                paymentMethod: paymentMethod,
                payedAmount: payedAmount,
                paymentDateTime: paymentDateTime,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({order = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (order) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.order,
                                referencedTable: $$PaymentsTableReferences
                                    ._orderTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._orderTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool order})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RestTablesTableTableManager get restTables =>
      $$RestTablesTableTableManager(_db, _db.restTables);
  $$ProductTypesTableTableTableManager get productTypesTable =>
      $$ProductTypesTableTableTableManager(_db, _db.productTypesTable);
  $$TaxesTableTableManager get taxes =>
      $$TaxesTableTableManager(_db, _db.taxes);
  $$ProductsClassTableTableManager get productsClass =>
      $$ProductsClassTableTableManager(_db, _db.productsClass);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderLinesTableTableManager get orderLines =>
      $$OrderLinesTableTableManager(_db, _db.orderLines);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
}
