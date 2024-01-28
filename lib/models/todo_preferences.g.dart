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
  properties: {},
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
) {}
TodoPreferences _todoPreferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoPreferences();
  object.id = id;
  return object;
}

P _todoPreferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
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
}

extension TodoPreferencesQueryObject
    on QueryBuilder<TodoPreferences, TodoPreferences, QFilterCondition> {}

extension TodoPreferencesQueryLinks
    on QueryBuilder<TodoPreferences, TodoPreferences, QFilterCondition> {}

extension TodoPreferencesQuerySortBy
    on QueryBuilder<TodoPreferences, TodoPreferences, QSortBy> {}

extension TodoPreferencesQuerySortThenBy
    on QueryBuilder<TodoPreferences, TodoPreferences, QSortThenBy> {
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
}

extension TodoPreferencesQueryWhereDistinct
    on QueryBuilder<TodoPreferences, TodoPreferences, QDistinct> {}

extension TodoPreferencesQueryProperty
    on QueryBuilder<TodoPreferences, TodoPreferences, QQueryProperty> {
  QueryBuilder<TodoPreferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
