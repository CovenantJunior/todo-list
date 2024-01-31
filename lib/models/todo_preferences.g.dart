// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_preferences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTodoPreferencesCollection on Isar {
  IsarCollection<TodoPreferences> get todoPreferences => this.collection();
}

const TodoPreferencesSchema = CollectionSchema(
  name: r'TodoPreferences',
  id: -1622823223089471975,
  properties: {
    r'autoDelete': PropertySchema(
      id: 0,
      name: r'autoDelete',
      type: IsarType.bool,
    ),
    r'autoSync': PropertySchema(
      id: 1,
      name: r'autoSync',
      type: IsarType.bool,
    ),
    r'backup': PropertySchema(
      id: 2,
      name: r'backup',
      type: IsarType.bool,
    ),
    r'darkMode': PropertySchema(
      id: 3,
      name: r'darkMode',
      type: IsarType.bool,
    ),
    r'notification': PropertySchema(
      id: 4,
      name: r'notification',
      type: IsarType.bool,
    )
  },
  estimateSize: _todoPreferencesEstimateSize,
  serialize: _todoPreferencesSerialize,
  deserialize: _todoPreferencesDeserialize,
  deserializeProp: _todoPreferencesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _todoPreferencesGetId,
  getLinks: _todoPreferencesGetLinks,
  attach: _todoPreferencesAttach,
  version: '3.1.0+1',
);

int _todoPreferencesEstimateSize(
  TodoPreferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _todoPreferencesSerialize(
  TodoPreferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoDelete);
  writer.writeBool(offsets[1], object.autoSync);
  writer.writeBool(offsets[2], object.backup);
  writer.writeBool(offsets[3], object.darkMode);
  writer.writeBool(offsets[4], object.notification);
}

TodoPreferences _todoPreferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoPreferences();
  object.autoDelete = reader.readBoolOrNull(offsets[0]);
  object.autoSync = reader.readBoolOrNull(offsets[1]);
  object.backup = reader.readBoolOrNull(offsets[2]);
  object.darkMode = reader.readBoolOrNull(offsets[3]);
  object.id = id;
  object.notification = reader.readBoolOrNull(offsets[4]);
  return object;
}

P _todoPreferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _todoPreferencesGetId(TodoPreferences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _todoPreferencesGetLinks(TodoPreferences object) {
  return [];
}

void _todoPreferencesAttach(
    IsarCollection<dynamic> col, Id id, TodoPreferences object) {
  object.id = id;
}

extension TodoPreferencesQueryWhereSort
    on QueryBuilder<TodoPreferences, TodoPreferences, QWhere> {
  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TodoPreferencesQueryWhere
    on QueryBuilder<TodoPreferences, TodoPreferences, QWhereClause> {
  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TodoPreferencesQueryFilter
    on QueryBuilder<TodoPreferences, TodoPreferences, QFilterCondition> {
  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoDeleteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'autoDelete',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoDeleteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'autoDelete',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoDeleteEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoDelete',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoSyncIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'autoSync',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoSyncIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'autoSync',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      autoSyncEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoSync',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      backupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backup',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      backupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'backup',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      backupEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backup',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      darkModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'darkMode',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      darkModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'darkMode',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      darkModeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'darkMode',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      notificationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notification',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      notificationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notification',
      ));
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterFilterCondition>
      notificationEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notification',
        value: value,
      ));
    });
  }
}

extension TodoPreferencesQueryObject
    on QueryBuilder<TodoPreferences, TodoPreferences, QFilterCondition> {}

extension TodoPreferencesQueryLinks
    on QueryBuilder<TodoPreferences, TodoPreferences, QFilterCondition> {}

extension TodoPreferencesQuerySortBy
    on QueryBuilder<TodoPreferences, TodoPreferences, QSortBy> {
  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByAutoDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDelete', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByAutoDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDelete', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByAutoSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSync', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByAutoSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSync', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy> sortByBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backup', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backup', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notification', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      sortByNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notification', Sort.desc);
    });
  }
}

extension TodoPreferencesQuerySortThenBy
    on QueryBuilder<TodoPreferences, TodoPreferences, QSortThenBy> {
  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByAutoDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDelete', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByAutoDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoDelete', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByAutoSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSync', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByAutoSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSync', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy> thenByBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backup', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backup', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notification', Sort.asc);
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QAfterSortBy>
      thenByNotificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notification', Sort.desc);
    });
  }
}

extension TodoPreferencesQueryWhereDistinct
    on QueryBuilder<TodoPreferences, TodoPreferences, QDistinct> {
  QueryBuilder<TodoPreferences, TodoPreferences, QDistinct>
      distinctByAutoDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoDelete');
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QDistinct>
      distinctByAutoSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoSync');
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QDistinct> distinctByBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backup');
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QDistinct>
      distinctByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'darkMode');
    });
  }

  QueryBuilder<TodoPreferences, TodoPreferences, QDistinct>
      distinctByNotification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notification');
    });
  }
}

extension TodoPreferencesQueryProperty
    on QueryBuilder<TodoPreferences, TodoPreferences, QQueryProperty> {
  QueryBuilder<TodoPreferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TodoPreferences, bool?, QQueryOperations> autoDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoDelete');
    });
  }

  QueryBuilder<TodoPreferences, bool?, QQueryOperations> autoSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoSync');
    });
  }

  QueryBuilder<TodoPreferences, bool?, QQueryOperations> backupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backup');
    });
  }

  QueryBuilder<TodoPreferences, bool?, QQueryOperations> darkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'darkMode');
    });
  }

  QueryBuilder<TodoPreferences, bool?, QQueryOperations>
      notificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notification');
    });
  }
}
