// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_score_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthlyScoreModelCollection on Isar {
  IsarCollection<MonthlyScoreModel> get monthlyScoreModels => this.collection();
}

const MonthlyScoreModelSchema = CollectionSchema(
  name: r'MonthlyScoreModel',
  id: -6529208024865833204,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'focusScore': PropertySchema(
      id: 1,
      name: r'focusScore',
      type: IsarType.long,
    ),
    r'habitScore': PropertySchema(
      id: 2,
      name: r'habitScore',
      type: IsarType.long,
    ),
    r'healthScore': PropertySchema(
      id: 3,
      name: r'healthScore',
      type: IsarType.long,
    ),
    r'monthStartDate': PropertySchema(
      id: 4,
      name: r'monthStartDate',
      type: IsarType.dateTime,
    ),
    r'scoreVersion': PropertySchema(
      id: 5,
      name: r'scoreVersion',
      type: IsarType.string,
    ),
    r'taskScore': PropertySchema(
      id: 6,
      name: r'taskScore',
      type: IsarType.long,
    ),
    r'totalScore': PropertySchema(
      id: 7,
      name: r'totalScore',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _monthlyScoreModelEstimateSize,
  serialize: _monthlyScoreModelSerialize,
  deserialize: _monthlyScoreModelDeserialize,
  deserializeProp: _monthlyScoreModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'monthStartDate': IndexSchema(
      id: -4767839651416462481,
      name: r'monthStartDate',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'monthStartDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _monthlyScoreModelGetId,
  getLinks: _monthlyScoreModelGetLinks,
  attach: _monthlyScoreModelAttach,
  version: '3.3.2',
);

int _monthlyScoreModelEstimateSize(
  MonthlyScoreModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.scoreVersion.length * 3;
  return bytesCount;
}

void _monthlyScoreModelSerialize(
  MonthlyScoreModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.focusScore);
  writer.writeLong(offsets[2], object.habitScore);
  writer.writeLong(offsets[3], object.healthScore);
  writer.writeDateTime(offsets[4], object.monthStartDate);
  writer.writeString(offsets[5], object.scoreVersion);
  writer.writeLong(offsets[6], object.taskScore);
  writer.writeLong(offsets[7], object.totalScore);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

MonthlyScoreModel _monthlyScoreModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyScoreModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.focusScore = reader.readLong(offsets[1]);
  object.habitScore = reader.readLong(offsets[2]);
  object.healthScore = reader.readLong(offsets[3]);
  object.id = id;
  object.monthStartDate = reader.readDateTime(offsets[4]);
  object.scoreVersion = reader.readString(offsets[5]);
  object.taskScore = reader.readLong(offsets[6]);
  object.totalScore = reader.readLong(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _monthlyScoreModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyScoreModelGetId(MonthlyScoreModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthlyScoreModelGetLinks(
  MonthlyScoreModel object,
) {
  return [];
}

void _monthlyScoreModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  MonthlyScoreModel object,
) {
  object.id = id;
}

extension MonthlyScoreModelByIndex on IsarCollection<MonthlyScoreModel> {
  Future<MonthlyScoreModel?> getByMonthStartDate(DateTime monthStartDate) {
    return getByIndex(r'monthStartDate', [monthStartDate]);
  }

  MonthlyScoreModel? getByMonthStartDateSync(DateTime monthStartDate) {
    return getByIndexSync(r'monthStartDate', [monthStartDate]);
  }

  Future<bool> deleteByMonthStartDate(DateTime monthStartDate) {
    return deleteByIndex(r'monthStartDate', [monthStartDate]);
  }

  bool deleteByMonthStartDateSync(DateTime monthStartDate) {
    return deleteByIndexSync(r'monthStartDate', [monthStartDate]);
  }

  Future<List<MonthlyScoreModel?>> getAllByMonthStartDate(
    List<DateTime> monthStartDateValues,
  ) {
    final values = monthStartDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'monthStartDate', values);
  }

  List<MonthlyScoreModel?> getAllByMonthStartDateSync(
    List<DateTime> monthStartDateValues,
  ) {
    final values = monthStartDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'monthStartDate', values);
  }

  Future<int> deleteAllByMonthStartDate(List<DateTime> monthStartDateValues) {
    final values = monthStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'monthStartDate', values);
  }

  int deleteAllByMonthStartDateSync(List<DateTime> monthStartDateValues) {
    final values = monthStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'monthStartDate', values);
  }

  Future<Id> putByMonthStartDate(MonthlyScoreModel object) {
    return putByIndex(r'monthStartDate', object);
  }

  Id putByMonthStartDateSync(
    MonthlyScoreModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'monthStartDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMonthStartDate(List<MonthlyScoreModel> objects) {
    return putAllByIndex(r'monthStartDate', objects);
  }

  List<Id> putAllByMonthStartDateSync(
    List<MonthlyScoreModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'monthStartDate', objects, saveLinks: saveLinks);
  }
}

extension MonthlyScoreModelQueryWhereSort
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QWhere> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhere>
  anyMonthStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'monthStartDate'),
      );
    });
  }
}

extension MonthlyScoreModelQueryWhere
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QWhereClause> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  monthStartDateEqualTo(DateTime monthStartDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'monthStartDate',
          value: [monthStartDate],
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  monthStartDateNotEqualTo(DateTime monthStartDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthStartDate',
                lower: [],
                upper: [monthStartDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthStartDate',
                lower: [monthStartDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthStartDate',
                lower: [monthStartDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'monthStartDate',
                lower: [],
                upper: [monthStartDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  monthStartDateGreaterThan(DateTime monthStartDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'monthStartDate',
          lower: [monthStartDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  monthStartDateLessThan(DateTime monthStartDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'monthStartDate',
          lower: [],
          upper: [monthStartDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterWhereClause>
  monthStartDateBetween(
    DateTime lowerMonthStartDate,
    DateTime upperMonthStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'monthStartDate',
          lower: [lowerMonthStartDate],
          includeLower: includeLower,
          upper: [upperMonthStartDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MonthlyScoreModelQueryFilter
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QFilterCondition> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  focusScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusScore', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  focusScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  focusScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  focusScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  habitScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitScore', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  habitScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  habitScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  habitScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  healthScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'healthScore', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  healthScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'healthScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  healthScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'healthScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  healthScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'healthScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  monthStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'monthStartDate', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  monthStartDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  monthStartDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  monthStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthStartDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scoreVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scoreVersion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scoreVersion',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  scoreVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  taskScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskScore', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  taskScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  taskScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  taskScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  totalScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalScore', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  totalScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  totalScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  totalScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterFilterCondition>
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
}

extension MonthlyScoreModelQueryObject
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QFilterCondition> {}

extension MonthlyScoreModelQueryLinks
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QFilterCondition> {}

extension MonthlyScoreModelQuerySortBy
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QSortBy> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByMonthStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthStartDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByMonthStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthStartDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MonthlyScoreModelQuerySortThenBy
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QSortThenBy> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByMonthStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthStartDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByMonthStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthStartDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MonthlyScoreModelQueryWhereDistinct
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct> {
  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByMonthStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthStartDate');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByScoreVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MonthlyScoreModelQueryProperty
    on QueryBuilder<MonthlyScoreModel, MonthlyScoreModel, QQueryProperty> {
  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyScoreModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> focusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> habitScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> healthScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, DateTime, QQueryOperations>
  monthStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthStartDate');
    });
  }

  QueryBuilder<MonthlyScoreModel, String, QQueryOperations>
  scoreVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreVersion');
    });
  }

  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> taskScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, int, QQueryOperations> totalScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScore');
    });
  }

  QueryBuilder<MonthlyScoreModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
