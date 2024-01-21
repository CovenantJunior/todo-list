// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTodoListCollection on Isar {
  IsarCollection<TodoList> get todoLists => this.collection();
}

const TodoListSchema = CollectionSchema(
  name: r'TodoList',
  id: 7701471819688667286,
  properties: {
    r'achieved': PropertySchema(
      id: 0,
      name: r'achieved',
      type: IsarType.dateTime,
    ),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'created': PropertySchema(
      id: 2,
      name: r'created',
      type: IsarType.dateTime,
    ),
    r'favorite': PropertySchema(
      id: 3,
      name: r'favorite',
      type: IsarType.bool,
    ),
    r'modified': PropertySchema(
      id: 4,
      name: r'modified',
      type: IsarType.dateTime,
    ),
    r'plan': PropertySchema(
      id: 5,
      name: r'plan',
      type: IsarType.string,
    )
  },
  estimateSize: _todoListEstimateSize,
  serialize: _todoListSerialize,
  deserialize: _todoListDeserialize,
  deserializeProp: _todoListDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _todoListGetId,
  getLinks: _todoListGetLinks,
  attach: _todoListAttach,
  version: '3.1.0+1',
);

int _todoListEstimateSize(
  TodoList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.plan;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _todoListSerialize(
  TodoList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.achieved);
  writer.writeBool(offsets[1], object.completed);
  writer.writeDateTime(offsets[2], object.created);
  writer.writeBool(offsets[3], object.favorite);
  writer.writeDateTime(offsets[4], object.modified);
  writer.writeString(offsets[5], object.plan);
}

TodoList _todoListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoList();
  object.achieved = reader.readDateTimeOrNull(offsets[0]);
  object.completed = reader.readBoolOrNull(offsets[1]);
  object.created = reader.readDateTimeOrNull(offsets[2]);
  object.favorite = reader.readBoolOrNull(offsets[3]);
  object.id = id;
  object.modified = reader.readDateTimeOrNull(offsets[4]);
  object.plan = reader.readStringOrNull(offsets[5]);
  return object;
}

P _todoListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _todoListGetId(TodoList object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _todoListGetLinks(TodoList object) {
  return [];
}

void _todoListAttach(IsarCollection<dynamic> col, Id id, TodoList object) {
  object.id = id;
}

extension TodoListQueryWhereSort on QueryBuilder<TodoList, TodoList, QWhere> {
  QueryBuilder<TodoList, TodoList, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TodoListQueryWhere on QueryBuilder<TodoList, TodoList, QWhereClause> {
  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterWhereClause> idBetween(
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

extension TodoListQueryFilter
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {
  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'achieved',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'achieved',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achieved',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achieved',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achieved',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> achievedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achieved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> completedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completed',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> completedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completed',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> completedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'created',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'created',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> createdBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> favoriteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'favorite',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> favoriteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'favorite',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> favoriteEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favorite',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modified',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modified',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modified',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modified',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modified',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> modifiedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plan',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plan',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plan',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> planIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plan',
        value: '',
      ));
    });
  }
}

extension TodoListQueryObject
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {}

extension TodoListQueryLinks
    on QueryBuilder<TodoList, TodoList, QFilterCondition> {}

extension TodoListQuerySortBy on QueryBuilder<TodoList, TodoList, QSortBy> {
  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByAchieved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achieved', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByAchievedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achieved', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modified', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modified', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plan', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plan', Sort.desc);
    });
  }
}

extension TodoListQuerySortThenBy
    on QueryBuilder<TodoList, TodoList, QSortThenBy> {
  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByAchieved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achieved', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByAchievedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achieved', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modified', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modified', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plan', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plan', Sort.desc);
    });
  }
}

extension TodoListQueryWhereDistinct
    on QueryBuilder<TodoList, TodoList, QDistinct> {
  QueryBuilder<TodoList, TodoList, QDistinct> distinctByAchieved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achieved');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favorite');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modified');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByPlan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plan', caseSensitive: caseSensitive);
    });
  }
}

extension TodoListQueryProperty
    on QueryBuilder<TodoList, TodoList, QQueryProperty> {
  QueryBuilder<TodoList, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TodoList, DateTime?, QQueryOperations> achievedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achieved');
    });
  }

  QueryBuilder<TodoList, bool?, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<TodoList, DateTime?, QQueryOperations> createdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created');
    });
  }

  QueryBuilder<TodoList, bool?, QQueryOperations> favoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favorite');
    });
  }

  QueryBuilder<TodoList, DateTime?, QQueryOperations> modifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modified');
    });
  }

  QueryBuilder<TodoList, String?, QQueryOperations> planProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plan');
    });
  }
}
