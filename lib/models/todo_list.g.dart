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
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 2,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'created': PropertySchema(
      id: 3,
      name: r'created',
      type: IsarType.dateTime,
    ),
    r'due': PropertySchema(
      id: 4,
      name: r'due',
      type: IsarType.dateTime,
    ),
    r'interval': PropertySchema(
      id: 5,
      name: r'interval',
      type: IsarType.string,
    ),
    r'modified': PropertySchema(
      id: 6,
      name: r'modified',
      type: IsarType.dateTime,
    ),
    r'plan': PropertySchema(
      id: 7,
      name: r'plan',
      type: IsarType.string,
    ),
    r'starred': PropertySchema(
      id: 8,
      name: r'starred',
      type: IsarType.bool,
    ),
    r'trashed': PropertySchema(
      id: 9,
      name: r'trashed',
      type: IsarType.bool,
    ),
    r'trashedDate': PropertySchema(
      id: 10,
      name: r'trashedDate',
      type: IsarType.dateTime,
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
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.interval;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
  writer.writeString(offsets[1], object.category);
  writer.writeBool(offsets[2], object.completed);
  writer.writeDateTime(offsets[3], object.created);
  writer.writeDateTime(offsets[4], object.due);
  writer.writeString(offsets[5], object.interval);
  writer.writeDateTime(offsets[6], object.modified);
  writer.writeString(offsets[7], object.plan);
  writer.writeBool(offsets[8], object.starred);
  writer.writeBool(offsets[9], object.trashed);
  writer.writeDateTime(offsets[10], object.trashedDate);
}

TodoList _todoListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoList();
  object.achieved = reader.readDateTimeOrNull(offsets[0]);
  object.category = reader.readStringOrNull(offsets[1]);
  object.completed = reader.readBoolOrNull(offsets[2]);
  object.created = reader.readDateTimeOrNull(offsets[3]);
  object.due = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.interval = reader.readStringOrNull(offsets[5]);
  object.modified = reader.readDateTimeOrNull(offsets[6]);
  object.plan = reader.readStringOrNull(offsets[7]);
  object.starred = reader.readBoolOrNull(offsets[8]);
  object.trashed = reader.readBoolOrNull(offsets[9]);
  object.trashedDate = reader.readDateTimeOrNull(offsets[10]);
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
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'due',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'due',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'due',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> dueBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'due',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'interval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'interval',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> intervalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'interval',
        value: '',
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

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> starredIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'starred',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> starredIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'starred',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> starredEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'starred',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trashed',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trashed',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trashed',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trashedDate',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      trashedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trashedDate',
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trashedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition>
      trashedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trashedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trashedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterFilterCondition> trashedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trashedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starred', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByStarredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starred', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashed', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByTrashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashed', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByTrashedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashedDate', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> sortByTrashedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashedDate', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'due', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starred', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByStarredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starred', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashed', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByTrashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashed', Sort.desc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByTrashedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashedDate', Sort.asc);
    });
  }

  QueryBuilder<TodoList, TodoList, QAfterSortBy> thenByTrashedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trashedDate', Sort.desc);
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

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
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

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'due');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByInterval(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval', caseSensitive: caseSensitive);
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

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'starred');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trashed');
    });
  }

  QueryBuilder<TodoList, TodoList, QDistinct> distinctByTrashedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trashedDate');
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

  QueryBuilder<TodoList, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
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

  QueryBuilder<TodoList, DateTime?, QQueryOperations> dueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'due');
    });
  }

  QueryBuilder<TodoList, String?, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
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

  QueryBuilder<TodoList, bool?, QQueryOperations> starredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'starred');
    });
  }

  QueryBuilder<TodoList, bool?, QQueryOperations> trashedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trashed');
    });
  }

  QueryBuilder<TodoList, DateTime?, QQueryOperations> trashedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trashedDate');
    });
  }
}
