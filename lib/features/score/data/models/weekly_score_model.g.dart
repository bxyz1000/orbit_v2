// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_score_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyScoreModelCollection on Isar {
  IsarCollection<WeeklyScoreModel> get weeklyScoreModels => this.collection();
}

const WeeklyScoreModelSchema = CollectionSchema(
  name: r'WeeklyScoreModel',
  id: 6588316318746885122,
  properties: {
    r'averageDailyScore': PropertySchema(
      id: 0,
      name: r'averageDailyScore',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'focusScore': PropertySchema(
      id: 2,
      name: r'focusScore',
      type: IsarType.long,
    ),
    r'habitScore': PropertySchema(
      id: 3,
      name: r'habitScore',
      type: IsarType.long,
    ),
    r'healthScore': PropertySchema(
      id: 4,
      name: r'healthScore',
      type: IsarType.long,
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
    r'weekStartDate': PropertySchema(
      id: 9,
      name: r'weekStartDate',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _weeklyScoreModelEstimateSize,
  serialize: _weeklyScoreModelSerialize,
  deserialize: _weeklyScoreModelDeserialize,
  deserializeProp: _weeklyScoreModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'weekStartDate': IndexSchema(
      id: 7906057668223877157,
      name: r'weekStartDate',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'weekStartDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _weeklyScoreModelGetId,
  getLinks: _weeklyScoreModelGetLinks,
  attach: _weeklyScoreModelAttach,
  version: '3.3.2',
);

int _weeklyScoreModelEstimateSize(
  WeeklyScoreModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.scoreVersion.length * 3;
  return bytesCount;
}

void _weeklyScoreModelSerialize(
  WeeklyScoreModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageDailyScore);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.focusScore);
  writer.writeLong(offsets[3], object.habitScore);
  writer.writeLong(offsets[4], object.healthScore);
  writer.writeString(offsets[5], object.scoreVersion);
  writer.writeLong(offsets[6], object.taskScore);
  writer.writeLong(offsets[7], object.totalScore);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeDateTime(offsets[9], object.weekStartDate);
}

WeeklyScoreModel _weeklyScoreModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyScoreModel();
  object.averageDailyScore = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.focusScore = reader.readLong(offsets[2]);
  object.habitScore = reader.readLong(offsets[3]);
  object.healthScore = reader.readLong(offsets[4]);
  object.id = id;
  object.scoreVersion = reader.readString(offsets[5]);
  object.taskScore = reader.readLong(offsets[6]);
  object.totalScore = reader.readLong(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.weekStartDate = reader.readDateTime(offsets[9]);
  return object;
}

P _weeklyScoreModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyScoreModelGetId(WeeklyScoreModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyScoreModelGetLinks(WeeklyScoreModel object) {
  return [];
}

void _weeklyScoreModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  WeeklyScoreModel object,
) {
  object.id = id;
}

extension WeeklyScoreModelByIndex on IsarCollection<WeeklyScoreModel> {
  Future<WeeklyScoreModel?> getByWeekStartDate(DateTime weekStartDate) {
    return getByIndex(r'weekStartDate', [weekStartDate]);
  }

  WeeklyScoreModel? getByWeekStartDateSync(DateTime weekStartDate) {
    return getByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<bool> deleteByWeekStartDate(DateTime weekStartDate) {
    return deleteByIndex(r'weekStartDate', [weekStartDate]);
  }

  bool deleteByWeekStartDateSync(DateTime weekStartDate) {
    return deleteByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<List<WeeklyScoreModel?>> getAllByWeekStartDate(
    List<DateTime> weekStartDateValues,
  ) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'weekStartDate', values);
  }

  List<WeeklyScoreModel?> getAllByWeekStartDateSync(
    List<DateTime> weekStartDateValues,
  ) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'weekStartDate', values);
  }

  Future<int> deleteAllByWeekStartDate(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'weekStartDate', values);
  }

  int deleteAllByWeekStartDateSync(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'weekStartDate', values);
  }

  Future<Id> putByWeekStartDate(WeeklyScoreModel object) {
    return putByIndex(r'weekStartDate', object);
  }

  Id putByWeekStartDateSync(WeeklyScoreModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'weekStartDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWeekStartDate(List<WeeklyScoreModel> objects) {
    return putAllByIndex(r'weekStartDate', objects);
  }

  List<Id> putAllByWeekStartDateSync(
    List<WeeklyScoreModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'weekStartDate', objects, saveLinks: saveLinks);
  }
}

extension WeeklyScoreModelQueryWhereSort
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QWhere> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhere>
  anyWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekStartDate'),
      );
    });
  }
}

extension WeeklyScoreModelQueryWhere
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QWhereClause> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  weekStartDateEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'weekStartDate',
          value: [weekStartDate],
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  weekStartDateNotEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekStartDate',
                lower: [],
                upper: [weekStartDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekStartDate',
                lower: [weekStartDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekStartDate',
                lower: [weekStartDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekStartDate',
                lower: [],
                upper: [weekStartDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  weekStartDateGreaterThan(DateTime weekStartDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekStartDate',
          lower: [weekStartDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  weekStartDateLessThan(DateTime weekStartDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekStartDate',
          lower: [],
          upper: [weekStartDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterWhereClause>
  weekStartDateBetween(
    DateTime lowerWeekStartDate,
    DateTime upperWeekStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekStartDate',
          lower: [lowerWeekStartDate],
          includeLower: includeLower,
          upper: [upperWeekStartDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WeeklyScoreModelQueryFilter
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QFilterCondition> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  averageDailyScoreEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageDailyScore',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  averageDailyScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageDailyScore',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  averageDailyScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageDailyScore',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  averageDailyScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageDailyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  focusScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusScore', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  habitScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitScore', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  healthScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'healthScore', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  scoreVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  scoreVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  taskScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskScore', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  totalScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalScore', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  weekStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekStartDate', value: value),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  weekStartDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  weekStartDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterFilterCondition>
  weekStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekStartDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WeeklyScoreModelQueryObject
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QFilterCondition> {}

extension WeeklyScoreModelQueryLinks
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QFilterCondition> {}

extension WeeklyScoreModelQuerySortBy
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QSortBy> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByAverageDailyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByAverageDailyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  sortByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyScoreModelQuerySortThenBy
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QSortThenBy> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByAverageDailyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByAverageDailyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByHealthScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'healthScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QAfterSortBy>
  thenByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyScoreModelQueryWhereDistinct
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct> {
  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByAverageDailyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageDailyScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByHealthScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'healthScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByScoreVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QDistinct>
  distinctByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStartDate');
    });
  }
}

extension WeeklyScoreModelQueryProperty
    on QueryBuilder<WeeklyScoreModel, WeeklyScoreModel, QQueryProperty> {
  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyScoreModel, double, QQueryOperations>
  averageDailyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageDailyScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> focusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> habitScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> healthScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'healthScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, String, QQueryOperations>
  scoreVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreVersion');
    });
  }

  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> taskScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, int, QQueryOperations> totalScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScore');
    });
  }

  QueryBuilder<WeeklyScoreModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<WeeklyScoreModel, DateTime, QQueryOperations>
  weekStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStartDate');
    });
  }
}
