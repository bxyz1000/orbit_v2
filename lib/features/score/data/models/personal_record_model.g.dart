// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_record_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonalRecordModelCollection on Isar {
  IsarCollection<PersonalRecordModel> get personalRecordModels =>
      this.collection();
}

const PersonalRecordModelSchema = CollectionSchema(
  name: r'PersonalRecordModel',
  id: 2247766566544950324,
  properties: {
    r'achievedAt': PropertySchema(
      id: 0,
      name: r'achievedAt',
      type: IsarType.dateTime,
    ),
    r'recordType': PropertySchema(
      id: 1,
      name: r'recordType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'value': PropertySchema(id: 3, name: r'value', type: IsarType.double),
  },

  estimateSize: _personalRecordModelEstimateSize,
  serialize: _personalRecordModelSerialize,
  deserialize: _personalRecordModelDeserialize,
  deserializeProp: _personalRecordModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'recordType': IndexSchema(
      id: 1442468683301829598,
      name: r'recordType',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'recordType',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _personalRecordModelGetId,
  getLinks: _personalRecordModelGetLinks,
  attach: _personalRecordModelAttach,
  version: '3.3.2',
);

int _personalRecordModelEstimateSize(
  PersonalRecordModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.recordType.length * 3;
  return bytesCount;
}

void _personalRecordModelSerialize(
  PersonalRecordModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.achievedAt);
  writer.writeString(offsets[1], object.recordType);
  writer.writeDateTime(offsets[2], object.updatedAt);
  writer.writeDouble(offsets[3], object.value);
}

PersonalRecordModel _personalRecordModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalRecordModel();
  object.achievedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.recordType = reader.readString(offsets[1]);
  object.updatedAt = reader.readDateTime(offsets[2]);
  object.value = reader.readDouble(offsets[3]);
  return object;
}

P _personalRecordModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _personalRecordModelGetId(PersonalRecordModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _personalRecordModelGetLinks(
  PersonalRecordModel object,
) {
  return [];
}

void _personalRecordModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PersonalRecordModel object,
) {
  object.id = id;
}

extension PersonalRecordModelByIndex on IsarCollection<PersonalRecordModel> {
  Future<PersonalRecordModel?> getByRecordType(String recordType) {
    return getByIndex(r'recordType', [recordType]);
  }

  PersonalRecordModel? getByRecordTypeSync(String recordType) {
    return getByIndexSync(r'recordType', [recordType]);
  }

  Future<bool> deleteByRecordType(String recordType) {
    return deleteByIndex(r'recordType', [recordType]);
  }

  bool deleteByRecordTypeSync(String recordType) {
    return deleteByIndexSync(r'recordType', [recordType]);
  }

  Future<List<PersonalRecordModel?>> getAllByRecordType(
    List<String> recordTypeValues,
  ) {
    final values = recordTypeValues.map((e) => [e]).toList();
    return getAllByIndex(r'recordType', values);
  }

  List<PersonalRecordModel?> getAllByRecordTypeSync(
    List<String> recordTypeValues,
  ) {
    final values = recordTypeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'recordType', values);
  }

  Future<int> deleteAllByRecordType(List<String> recordTypeValues) {
    final values = recordTypeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'recordType', values);
  }

  int deleteAllByRecordTypeSync(List<String> recordTypeValues) {
    final values = recordTypeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'recordType', values);
  }

  Future<Id> putByRecordType(PersonalRecordModel object) {
    return putByIndex(r'recordType', object);
  }

  Id putByRecordTypeSync(PersonalRecordModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'recordType', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecordType(List<PersonalRecordModel> objects) {
    return putAllByIndex(r'recordType', objects);
  }

  List<Id> putAllByRecordTypeSync(
    List<PersonalRecordModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'recordType', objects, saveLinks: saveLinks);
  }
}

extension PersonalRecordModelQueryWhereSort
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QWhere> {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonalRecordModelQueryWhere
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QWhereClause> {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
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

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  recordTypeEqualTo(String recordType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'recordType', value: [recordType]),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterWhereClause>
  recordTypeNotEqualTo(String recordType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordType',
                lower: [],
                upper: [recordType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordType',
                lower: [recordType],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordType',
                lower: [recordType],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordType',
                lower: [],
                upper: [recordType],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PersonalRecordModelQueryFilter
    on
        QueryBuilder<
          PersonalRecordModel,
          PersonalRecordModel,
          QFilterCondition
        > {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  achievedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'achievedAt', value: value),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  achievedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'achievedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  achievedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'achievedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  achievedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'achievedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recordType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recordType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recordType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recordType', value: ''),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  recordTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recordType', value: ''),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  valueEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterFilterCondition>
  valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension PersonalRecordModelQueryObject
    on
        QueryBuilder<
          PersonalRecordModel,
          PersonalRecordModel,
          QFilterCondition
        > {}

extension PersonalRecordModelQueryLinks
    on
        QueryBuilder<
          PersonalRecordModel,
          PersonalRecordModel,
          QFilterCondition
        > {}

extension PersonalRecordModelQuerySortBy
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QSortBy> {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByRecordType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByRecordTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension PersonalRecordModelQuerySortThenBy
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QSortThenBy> {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByRecordType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByRecordTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QAfterSortBy>
  thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension PersonalRecordModelQueryWhereDistinct
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QDistinct> {
  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QDistinct>
  distinctByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievedAt');
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QDistinct>
  distinctByRecordType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PersonalRecordModel, PersonalRecordModel, QDistinct>
  distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension PersonalRecordModelQueryProperty
    on QueryBuilder<PersonalRecordModel, PersonalRecordModel, QQueryProperty> {
  QueryBuilder<PersonalRecordModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersonalRecordModel, DateTime, QQueryOperations>
  achievedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievedAt');
    });
  }

  QueryBuilder<PersonalRecordModel, String, QQueryOperations>
  recordTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordType');
    });
  }

  QueryBuilder<PersonalRecordModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PersonalRecordModel, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
