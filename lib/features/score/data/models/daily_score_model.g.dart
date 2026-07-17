// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_score_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyScoreModelCollection on Isar {
  IsarCollection<DailyScoreModel> get dailyScoreModels => this.collection();
}

const DailyScoreModelSchema = CollectionSchema(
  name: r'DailyScoreModel',
  id: -7931950307066935883,
  properties: {
    r'bonusScore': PropertySchema(
      id: 0,
      name: r'bonusScore',
      type: IsarType.long,
    ),
    r'consistencyScore': PropertySchema(
      id: 1,
      name: r'consistencyScore',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.dateTime),
    r'focusScore': PropertySchema(
      id: 4,
      name: r'focusScore',
      type: IsarType.long,
    ),
    r'goalScore': PropertySchema(
      id: 5,
      name: r'goalScore',
      type: IsarType.long,
    ),
    r'habitScore': PropertySchema(
      id: 6,
      name: r'habitScore',
      type: IsarType.long,
    ),
    r'isFinalized': PropertySchema(
      id: 7,
      name: r'isFinalized',
      type: IsarType.bool,
    ),
    r'penaltyScore': PropertySchema(
      id: 8,
      name: r'penaltyScore',
      type: IsarType.long,
    ),
    r'plannerScore': PropertySchema(
      id: 9,
      name: r'plannerScore',
      type: IsarType.long,
    ),
    r'scoreVersion': PropertySchema(
      id: 10,
      name: r'scoreVersion',
      type: IsarType.string,
    ),
    r'sleepScore': PropertySchema(
      id: 11,
      name: r'sleepScore',
      type: IsarType.long,
    ),
    r'stepsScore': PropertySchema(
      id: 12,
      name: r'stepsScore',
      type: IsarType.long,
    ),
    r'taskScore': PropertySchema(
      id: 13,
      name: r'taskScore',
      type: IsarType.long,
    ),
    r'totalScore': PropertySchema(
      id: 14,
      name: r'totalScore',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workoutScore': PropertySchema(
      id: 16,
      name: r'workoutScore',
      type: IsarType.long,
    ),
  },

  estimateSize: _dailyScoreModelEstimateSize,
  serialize: _dailyScoreModelSerialize,
  deserialize: _dailyScoreModelDeserialize,
  deserializeProp: _dailyScoreModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _dailyScoreModelGetId,
  getLinks: _dailyScoreModelGetLinks,
  attach: _dailyScoreModelAttach,
  version: '3.3.2',
);

int _dailyScoreModelEstimateSize(
  DailyScoreModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.scoreVersion.length * 3;
  return bytesCount;
}

void _dailyScoreModelSerialize(
  DailyScoreModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bonusScore);
  writer.writeLong(offsets[1], object.consistencyScore);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeLong(offsets[4], object.focusScore);
  writer.writeLong(offsets[5], object.goalScore);
  writer.writeLong(offsets[6], object.habitScore);
  writer.writeBool(offsets[7], object.isFinalized);
  writer.writeLong(offsets[8], object.penaltyScore);
  writer.writeLong(offsets[9], object.plannerScore);
  writer.writeString(offsets[10], object.scoreVersion);
  writer.writeLong(offsets[11], object.sleepScore);
  writer.writeLong(offsets[12], object.stepsScore);
  writer.writeLong(offsets[13], object.taskScore);
  writer.writeLong(offsets[14], object.totalScore);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeLong(offsets[16], object.workoutScore);
}

DailyScoreModel _dailyScoreModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyScoreModel();
  object.bonusScore = reader.readLong(offsets[0]);
  object.consistencyScore = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.focusScore = reader.readLong(offsets[4]);
  object.goalScore = reader.readLong(offsets[5]);
  object.habitScore = reader.readLong(offsets[6]);
  object.id = id;
  object.isFinalized = reader.readBool(offsets[7]);
  object.penaltyScore = reader.readLong(offsets[8]);
  object.plannerScore = reader.readLong(offsets[9]);
  object.scoreVersion = reader.readString(offsets[10]);
  object.sleepScore = reader.readLong(offsets[11]);
  object.stepsScore = reader.readLong(offsets[12]);
  object.taskScore = reader.readLong(offsets[13]);
  object.totalScore = reader.readLong(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  object.workoutScore = reader.readLong(offsets[16]);
  return object;
}

P _dailyScoreModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyScoreModelGetId(DailyScoreModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyScoreModelGetLinks(DailyScoreModel object) {
  return [];
}

void _dailyScoreModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DailyScoreModel object,
) {
  object.id = id;
}

extension DailyScoreModelByIndex on IsarCollection<DailyScoreModel> {
  Future<DailyScoreModel?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyScoreModel? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyScoreModel?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyScoreModel?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyScoreModel object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyScoreModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyScoreModel> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(
    List<DailyScoreModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyScoreModelQueryWhereSort
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QWhere> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyScoreModelQueryWhere
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QWhereClause> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause> dateEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause>
  dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause>
  dateGreaterThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause>
  dateLessThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailyScoreModelQueryFilter
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QFilterCondition> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  bonusScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bonusScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  bonusScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bonusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  bonusScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bonusScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  bonusScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bonusScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  consistencyScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'consistencyScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  consistencyScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'consistencyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  consistencyScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'consistencyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  consistencyScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'consistencyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  focusScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  goalScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  goalScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'goalScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  goalScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'goalScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  goalScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'goalScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  habitScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  isFinalizedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFinalized', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  penaltyScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'penaltyScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  penaltyScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'penaltyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  penaltyScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'penaltyScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  penaltyScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'penaltyScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  plannerScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannerScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  plannerScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannerScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  plannerScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannerScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  plannerScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannerScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  scoreVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  scoreVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scoreVersion', value: ''),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  sleepScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sleepScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  sleepScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sleepScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  sleepScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sleepScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  sleepScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sleepScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  stepsScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stepsScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  stepsScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stepsScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  stepsScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stepsScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  stepsScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stepsScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  taskScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  totalScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
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

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  workoutScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutScore', value: value),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  workoutScoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  workoutScoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutScore',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterFilterCondition>
  workoutScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutScore',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailyScoreModelQueryObject
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QFilterCondition> {}

extension DailyScoreModelQueryLinks
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QFilterCondition> {}

extension DailyScoreModelQuerySortBy
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QSortBy> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByBonusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByBonusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByGoalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByGoalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByIsFinalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinalized', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByIsFinalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinalized', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByPenaltyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByPenaltyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByPlannerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannerScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByPlannerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannerScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByStepsScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByStepsScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByWorkoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  sortByWorkoutScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutScore', Sort.desc);
    });
  }
}

extension DailyScoreModelQuerySortThenBy
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QSortThenBy> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByBonusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByBonusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByGoalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByGoalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByHabitScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByIsFinalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinalized', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByIsFinalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFinalized', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByPenaltyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByPenaltyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'penaltyScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByPlannerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannerScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByPlannerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannerScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByScoreVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByScoreVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreVersion', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByStepsScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByStepsScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByTaskScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByTotalScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScore', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByWorkoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutScore', Sort.asc);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QAfterSortBy>
  thenByWorkoutScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutScore', Sort.desc);
    });
  }
}

extension DailyScoreModelQueryWhereDistinct
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct> {
  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByBonusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bonusScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consistencyScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByGoalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByHabitScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByIsFinalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFinalized');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByPenaltyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'penaltyScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByPlannerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannerScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByScoreVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByStepsScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepsScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByTaskScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByTotalScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScore');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<DailyScoreModel, DailyScoreModel, QDistinct>
  distinctByWorkoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutScore');
    });
  }
}

extension DailyScoreModelQueryProperty
    on QueryBuilder<DailyScoreModel, DailyScoreModel, QQueryProperty> {
  QueryBuilder<DailyScoreModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> bonusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bonusScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations>
  consistencyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consistencyScore');
    });
  }

  QueryBuilder<DailyScoreModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailyScoreModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> focusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> goalScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> habitScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitScore');
    });
  }

  QueryBuilder<DailyScoreModel, bool, QQueryOperations> isFinalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFinalized');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> penaltyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'penaltyScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> plannerScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannerScore');
    });
  }

  QueryBuilder<DailyScoreModel, String, QQueryOperations>
  scoreVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreVersion');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> sleepScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> stepsScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepsScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> taskScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskScore');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> totalScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScore');
    });
  }

  QueryBuilder<DailyScoreModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<DailyScoreModel, int, QQueryOperations> workoutScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutScore');
    });
  }
}
