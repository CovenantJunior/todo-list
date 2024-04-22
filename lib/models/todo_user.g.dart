// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_user.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTodoUserCollection on Isar {
  IsarCollection<TodoUser> get todoUsers => this.collection();
}

const TodoUserSchema = CollectionSchema(
  name: r'TodoUser',
  id: 7397912175288058872,
  properties: {
    r'authToken': PropertySchema(
      id: 0,
      name: r'authToken',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(
      id: 2,
      name: r'email',
      type: IsarType.string,
    ),
    r'googleUserId': PropertySchema(
      id: 3,
      name: r'googleUserId',
      type: IsarType.string,
    ),
    r'googleUserPhotoUrl': PropertySchema(
      id: 4,
      name: r'googleUserPhotoUrl',
      type: IsarType.string,
    ),
    r'lastBackup': PropertySchema(
      id: 5,
      name: r'lastBackup',
      type: IsarType.dateTime,
    ),
    r'pro': PropertySchema(
      id: 6,
      name: r'pro',
      type: IsarType.bool,
    ),
    r'signed': PropertySchema(
      id: 7,
      name: r'signed',
      type: IsarType.bool,
    ),
    r'username': PropertySchema(
      id: 8,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _todoUserEstimateSize,
  serialize: _todoUserSerialize,
  deserialize: _todoUserDeserialize,
  deserializeProp: _todoUserDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _todoUserGetId,
  getLinks: _todoUserGetLinks,
  attach: _todoUserAttach,
  version: '3.1.0+1',
);

int _todoUserEstimateSize(
  TodoUser object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.authToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.googleUserId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.googleUserPhotoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _todoUserSerialize(
  TodoUser object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.authToken);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.email);
  writer.writeString(offsets[3], object.googleUserId);
  writer.writeString(offsets[4], object.googleUserPhotoUrl);
  writer.writeDateTime(offsets[5], object.lastBackup);
  writer.writeBool(offsets[6], object.pro);
  writer.writeBool(offsets[7], object.signed);
  writer.writeString(offsets[8], object.username);
}

TodoUser _todoUserDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TodoUser();
  object.authToken = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTimeOrNull(offsets[1]);
  object.email = reader.readStringOrNull(offsets[2]);
  object.googleUserId = reader.readStringOrNull(offsets[3]);
  object.googleUserPhotoUrl = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.lastBackup = reader.readDateTimeOrNull(offsets[5]);
  object.pro = reader.readBoolOrNull(offsets[6]);
  object.signed = reader.readBoolOrNull(offsets[7]);
  object.username = reader.readStringOrNull(offsets[8]);
  return object;
}

P _todoUserDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _todoUserGetId(TodoUser object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _todoUserGetLinks(TodoUser object) {
  return [];
}

void _todoUserAttach(IsarCollection<dynamic> col, Id id, TodoUser object) {
  object.id = id;
}

extension TodoUserQueryWhereSort on QueryBuilder<TodoUser, TodoUser, QWhere> {
  QueryBuilder<TodoUser, TodoUser, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TodoUserQueryWhere on QueryBuilder<TodoUser, TodoUser, QWhereClause> {
  QueryBuilder<TodoUser, TodoUser, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TodoUser, TodoUser, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterWhereClause> idBetween(
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

extension TodoUserQueryFilter
    on QueryBuilder<TodoUser, TodoUser, QFilterCondition> {
  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'authToken',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'authToken',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> authTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      authTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authToken',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'googleUserId',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'googleUserId',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'googleUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'googleUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> googleUserIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'googleUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'googleUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'googleUserPhotoUrl',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'googleUserPhotoUrl',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'googleUserPhotoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'googleUserPhotoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'googleUserPhotoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleUserPhotoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      googleUserPhotoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'googleUserPhotoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> lastBackupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastBackup',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition>
      lastBackupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastBackup',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> lastBackupEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBackup',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> lastBackupGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBackup',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> lastBackupLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBackup',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> lastBackupBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBackup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> proIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pro',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> proIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pro',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> proEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pro',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> signedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signed',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> signedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signed',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> signedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signed',
        value: value,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension TodoUserQueryObject
    on QueryBuilder<TodoUser, TodoUser, QFilterCondition> {}

extension TodoUserQueryLinks
    on QueryBuilder<TodoUser, TodoUser, QFilterCondition> {}

extension TodoUserQuerySortBy on QueryBuilder<TodoUser, TodoUser, QSortBy> {
  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByAuthToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByAuthTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByGoogleUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserId', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByGoogleUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserId', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByGoogleUserPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserPhotoUrl', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy>
      sortByGoogleUserPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserPhotoUrl', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByLastBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackup', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByLastBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackup', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByPro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pro', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByProDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pro', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortBySigned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signed', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortBySignedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signed', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension TodoUserQuerySortThenBy
    on QueryBuilder<TodoUser, TodoUser, QSortThenBy> {
  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByAuthToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByAuthTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByGoogleUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserId', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByGoogleUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserId', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByGoogleUserPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserPhotoUrl', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy>
      thenByGoogleUserPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleUserPhotoUrl', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByLastBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackup', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByLastBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackup', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByPro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pro', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByProDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pro', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenBySigned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signed', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenBySignedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signed', Sort.desc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension TodoUserQueryWhereDistinct
    on QueryBuilder<TodoUser, TodoUser, QDistinct> {
  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByAuthToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByGoogleUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googleUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByGoogleUserPhotoUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googleUserPhotoUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByLastBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBackup');
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByPro() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pro');
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctBySigned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signed');
    });
  }

  QueryBuilder<TodoUser, TodoUser, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension TodoUserQueryProperty
    on QueryBuilder<TodoUser, TodoUser, QQueryProperty> {
  QueryBuilder<TodoUser, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TodoUser, String?, QQueryOperations> authTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authToken');
    });
  }

  QueryBuilder<TodoUser, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TodoUser, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<TodoUser, String?, QQueryOperations> googleUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleUserId');
    });
  }

  QueryBuilder<TodoUser, String?, QQueryOperations>
      googleUserPhotoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleUserPhotoUrl');
    });
  }

  QueryBuilder<TodoUser, DateTime?, QQueryOperations> lastBackupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackup');
    });
  }

  QueryBuilder<TodoUser, bool?, QQueryOperations> proProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pro');
    });
  }

  QueryBuilder<TodoUser, bool?, QQueryOperations> signedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signed');
    });
  }

  QueryBuilder<TodoUser, String?, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
