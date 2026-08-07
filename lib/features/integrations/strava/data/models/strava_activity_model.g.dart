// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strava_activity_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStravaActivityModelCollection on Isar {
  IsarCollection<StravaActivityModel> get stravaActivityModels =>
      this.collection();
}

const StravaActivityModelSchema = CollectionSchema(
  name: r'StravaActivityModel',
  id: 1198991276367402984,
  properties: {
    r'averageSpeed': PropertySchema(
      id: 0,
      name: r'averageSpeed',
      type: IsarType.double,
    ),
    r'calories': PropertySchema(
      id: 1,
      name: r'calories',
      type: IsarType.double,
    ),
    r'distanceMeters': PropertySchema(
      id: 2,
      name: r'distanceMeters',
      type: IsarType.double,
    ),
    r'elapsedTimeSeconds': PropertySchema(
      id: 3,
      name: r'elapsedTimeSeconds',
      type: IsarType.long,
    ),
    r'elevationGainMeters': PropertySchema(
      id: 4,
      name: r'elevationGainMeters',
      type: IsarType.double,
    ),
    r'maxSpeed': PropertySchema(
      id: 5,
      name: r'maxSpeed',
      type: IsarType.double,
    ),
    r'movingTimeSeconds': PropertySchema(
      id: 6,
      name: r'movingTimeSeconds',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 7, name: r'name', type: IsarType.string),
    r'startDate': PropertySchema(
      id: 8,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'stravaId': PropertySchema(
      id: 9,
      name: r'stravaId',
      type: IsarType.string,
    ),
    r'syncedAt': PropertySchema(
      id: 10,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(id: 11, name: r'type', type: IsarType.string),
  },

  estimateSize: _stravaActivityModelEstimateSize,
  serialize: _stravaActivityModelSerialize,
  deserialize: _stravaActivityModelDeserialize,
  deserializeProp: _stravaActivityModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'stravaId': IndexSchema(
      id: 3559372165434007524,
      name: r'stravaId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'stravaId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _stravaActivityModelGetId,
  getLinks: _stravaActivityModelGetLinks,
  attach: _stravaActivityModelAttach,
  version: '3.3.2',
);

int _stravaActivityModelEstimateSize(
  StravaActivityModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.stravaId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _stravaActivityModelSerialize(
  StravaActivityModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageSpeed);
  writer.writeDouble(offsets[1], object.calories);
  writer.writeDouble(offsets[2], object.distanceMeters);
  writer.writeLong(offsets[3], object.elapsedTimeSeconds);
  writer.writeDouble(offsets[4], object.elevationGainMeters);
  writer.writeDouble(offsets[5], object.maxSpeed);
  writer.writeLong(offsets[6], object.movingTimeSeconds);
  writer.writeString(offsets[7], object.name);
  writer.writeDateTime(offsets[8], object.startDate);
  writer.writeString(offsets[9], object.stravaId);
  writer.writeDateTime(offsets[10], object.syncedAt);
  writer.writeString(offsets[11], object.type);
}

StravaActivityModel _stravaActivityModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StravaActivityModel();
  object.averageSpeed = reader.readDouble(offsets[0]);
  object.calories = reader.readDoubleOrNull(offsets[1]);
  object.distanceMeters = reader.readDouble(offsets[2]);
  object.elapsedTimeSeconds = reader.readLong(offsets[3]);
  object.elevationGainMeters = reader.readDouble(offsets[4]);
  object.id = id;
  object.maxSpeed = reader.readDouble(offsets[5]);
  object.movingTimeSeconds = reader.readLong(offsets[6]);
  object.name = reader.readString(offsets[7]);
  object.startDate = reader.readDateTime(offsets[8]);
  object.stravaId = reader.readString(offsets[9]);
  object.syncedAt = reader.readDateTime(offsets[10]);
  object.type = reader.readString(offsets[11]);
  return object;
}

P _stravaActivityModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stravaActivityModelGetId(StravaActivityModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stravaActivityModelGetLinks(
  StravaActivityModel object,
) {
  return [];
}

void _stravaActivityModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  StravaActivityModel object,
) {
  object.id = id;
}

extension StravaActivityModelByIndex on IsarCollection<StravaActivityModel> {
  Future<StravaActivityModel?> getByStravaId(String stravaId) {
    return getByIndex(r'stravaId', [stravaId]);
  }

  StravaActivityModel? getByStravaIdSync(String stravaId) {
    return getByIndexSync(r'stravaId', [stravaId]);
  }

  Future<bool> deleteByStravaId(String stravaId) {
    return deleteByIndex(r'stravaId', [stravaId]);
  }

  bool deleteByStravaIdSync(String stravaId) {
    return deleteByIndexSync(r'stravaId', [stravaId]);
  }

  Future<List<StravaActivityModel?>> getAllByStravaId(
    List<String> stravaIdValues,
  ) {
    final values = stravaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'stravaId', values);
  }

  List<StravaActivityModel?> getAllByStravaIdSync(List<String> stravaIdValues) {
    final values = stravaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'stravaId', values);
  }

  Future<int> deleteAllByStravaId(List<String> stravaIdValues) {
    final values = stravaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'stravaId', values);
  }

  int deleteAllByStravaIdSync(List<String> stravaIdValues) {
    final values = stravaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'stravaId', values);
  }

  Future<Id> putByStravaId(StravaActivityModel object) {
    return putByIndex(r'stravaId', object);
  }

  Id putByStravaIdSync(StravaActivityModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'stravaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStravaId(List<StravaActivityModel> objects) {
    return putAllByIndex(r'stravaId', objects);
  }

  List<Id> putAllByStravaIdSync(
    List<StravaActivityModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'stravaId', objects, saveLinks: saveLinks);
  }
}

extension StravaActivityModelQueryWhereSort
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QWhere> {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StravaActivityModelQueryWhere
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QWhereClause> {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
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

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
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

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
  stravaIdEqualTo(String stravaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'stravaId', value: [stravaId]),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterWhereClause>
  stravaIdNotEqualTo(String stravaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stravaId',
                lower: [],
                upper: [stravaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stravaId',
                lower: [stravaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stravaId',
                lower: [stravaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'stravaId',
                lower: [],
                upper: [stravaId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension StravaActivityModelQueryFilter
    on
        QueryBuilder<
          StravaActivityModel,
          StravaActivityModel,
          QFilterCondition
        > {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  averageSpeedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averageSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  averageSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averageSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  averageSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averageSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  averageSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averageSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'calories'),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'calories'),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'calories',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'calories',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'calories',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  caloriesBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'calories',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  distanceMetersEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'distanceMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  distanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'distanceMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  distanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'distanceMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  distanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'distanceMeters',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elapsedTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'elapsedTimeSeconds', value: value),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elapsedTimeSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'elapsedTimeSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elapsedTimeSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'elapsedTimeSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elapsedTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'elapsedTimeSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elevationGainMetersEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'elevationGainMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elevationGainMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'elevationGainMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elevationGainMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'elevationGainMeters',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  elevationGainMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'elevationGainMeters',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
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

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
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

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
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

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  maxSpeedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'maxSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  maxSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maxSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  maxSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maxSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  maxSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maxSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  movingTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movingTimeSeconds', value: value),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  movingTimeSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movingTimeSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  movingTimeSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movingTimeSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  movingTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movingTimeSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  startDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  startDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stravaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stravaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stravaId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stravaId', value: ''),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  stravaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stravaId', value: ''),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: value),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  syncedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  syncedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }
}

extension StravaActivityModelQueryObject
    on
        QueryBuilder<
          StravaActivityModel,
          StravaActivityModel,
          QFilterCondition
        > {}

extension StravaActivityModelQueryLinks
    on
        QueryBuilder<
          StravaActivityModel,
          StravaActivityModel,
          QFilterCondition
        > {}

extension StravaActivityModelQuerySortBy
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QSortBy> {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByElapsedTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByElapsedTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByElevationGainMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elevationGainMeters', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByElevationGainMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elevationGainMeters', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByMaxSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeed', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByMaxSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeed', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByMovingTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByMovingTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByStravaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stravaId', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByStravaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stravaId', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension StravaActivityModelQuerySortThenBy
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QSortThenBy> {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByElapsedTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByElapsedTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elapsedTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByElevationGainMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elevationGainMeters', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByElevationGainMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'elevationGainMeters', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByMaxSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeed', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByMaxSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeed', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByMovingTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByMovingTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByStravaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stravaId', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByStravaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stravaId', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension StravaActivityModelQueryWhereDistinct
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct> {
  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageSpeed');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distanceMeters');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByElapsedTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'elapsedTimeSeconds');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByElevationGainMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'elevationGainMeters');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByMaxSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSpeed');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByMovingTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movingTimeSeconds');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByStravaId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stravaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<StravaActivityModel, StravaActivityModel, QDistinct>
  distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension StravaActivityModelQueryProperty
    on QueryBuilder<StravaActivityModel, StravaActivityModel, QQueryProperty> {
  QueryBuilder<StravaActivityModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StravaActivityModel, double, QQueryOperations>
  averageSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageSpeed');
    });
  }

  QueryBuilder<StravaActivityModel, double?, QQueryOperations>
  caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<StravaActivityModel, double, QQueryOperations>
  distanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distanceMeters');
    });
  }

  QueryBuilder<StravaActivityModel, int, QQueryOperations>
  elapsedTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elapsedTimeSeconds');
    });
  }

  QueryBuilder<StravaActivityModel, double, QQueryOperations>
  elevationGainMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elevationGainMeters');
    });
  }

  QueryBuilder<StravaActivityModel, double, QQueryOperations>
  maxSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSpeed');
    });
  }

  QueryBuilder<StravaActivityModel, int, QQueryOperations>
  movingTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movingTimeSeconds');
    });
  }

  QueryBuilder<StravaActivityModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<StravaActivityModel, DateTime, QQueryOperations>
  startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<StravaActivityModel, String, QQueryOperations>
  stravaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stravaId');
    });
  }

  QueryBuilder<StravaActivityModel, DateTime, QQueryOperations>
  syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<StravaActivityModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
