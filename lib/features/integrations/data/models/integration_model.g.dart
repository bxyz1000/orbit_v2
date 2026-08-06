// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIntegrationModelCollection on Isar {
  IsarCollection<IntegrationModel> get integrationModels => this.collection();
}

const IntegrationModelSchema = CollectionSchema(
  name: r'IntegrationModel',
  id: 2031226668022466059,
  properties: {
    r'isSupported': PropertySchema(
      id: 0,
      name: r'isSupported',
      type: IsarType.bool,
    ),
    r'lastSync': PropertySchema(
      id: 1,
      name: r'lastSync',
      type: IsarType.dateTime,
    ),
    r'metadataJson': PropertySchema(
      id: 2,
      name: r'metadataJson',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'orbitId': PropertySchema(id: 4, name: r'orbitId', type: IsarType.string),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.byte,
      enumMap: _IntegrationModelstatusEnumValueMap,
    ),
  },

  estimateSize: _integrationModelEstimateSize,
  serialize: _integrationModelSerialize,
  deserialize: _integrationModelDeserialize,
  deserializeProp: _integrationModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'orbitId': IndexSchema(
      id: -5160130454438981071,
      name: r'orbitId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'orbitId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _integrationModelGetId,
  getLinks: _integrationModelGetLinks,
  attach: _integrationModelAttach,
  version: '3.3.2',
);

int _integrationModelEstimateSize(
  IntegrationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.metadataJson.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.orbitId.length * 3;
  return bytesCount;
}

void _integrationModelSerialize(
  IntegrationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSupported);
  writer.writeDateTime(offsets[1], object.lastSync);
  writer.writeString(offsets[2], object.metadataJson);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.orbitId);
  writer.writeByte(offsets[5], object.status.index);
}

IntegrationModel _integrationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IntegrationModel();
  object.id = id;
  object.isSupported = reader.readBool(offsets[0]);
  object.lastSync = reader.readDateTimeOrNull(offsets[1]);
  object.metadataJson = reader.readString(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.orbitId = reader.readString(offsets[4]);
  object.status =
      _IntegrationModelstatusValueEnumMap[reader.readByteOrNull(offsets[5])] ??
      IntegrationStatus.connected;
  return object;
}

P _integrationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (_IntegrationModelstatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              IntegrationStatus.connected)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _IntegrationModelstatusEnumValueMap = {
  'connected': 0,
  'syncing': 1,
  'error': 2,
  'notConnected': 3,
};
const _IntegrationModelstatusValueEnumMap = {
  0: IntegrationStatus.connected,
  1: IntegrationStatus.syncing,
  2: IntegrationStatus.error,
  3: IntegrationStatus.notConnected,
};

Id _integrationModelGetId(IntegrationModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _integrationModelGetLinks(IntegrationModel object) {
  return [];
}

void _integrationModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  IntegrationModel object,
) {
  object.id = id;
}

extension IntegrationModelByIndex on IsarCollection<IntegrationModel> {
  Future<IntegrationModel?> getByOrbitId(String orbitId) {
    return getByIndex(r'orbitId', [orbitId]);
  }

  IntegrationModel? getByOrbitIdSync(String orbitId) {
    return getByIndexSync(r'orbitId', [orbitId]);
  }

  Future<bool> deleteByOrbitId(String orbitId) {
    return deleteByIndex(r'orbitId', [orbitId]);
  }

  bool deleteByOrbitIdSync(String orbitId) {
    return deleteByIndexSync(r'orbitId', [orbitId]);
  }

  Future<List<IntegrationModel?>> getAllByOrbitId(List<String> orbitIdValues) {
    final values = orbitIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'orbitId', values);
  }

  List<IntegrationModel?> getAllByOrbitIdSync(List<String> orbitIdValues) {
    final values = orbitIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'orbitId', values);
  }

  Future<int> deleteAllByOrbitId(List<String> orbitIdValues) {
    final values = orbitIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'orbitId', values);
  }

  int deleteAllByOrbitIdSync(List<String> orbitIdValues) {
    final values = orbitIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'orbitId', values);
  }

  Future<Id> putByOrbitId(IntegrationModel object) {
    return putByIndex(r'orbitId', object);
  }

  Id putByOrbitIdSync(IntegrationModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'orbitId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOrbitId(List<IntegrationModel> objects) {
    return putAllByIndex(r'orbitId', objects);
  }

  List<Id> putAllByOrbitIdSync(
    List<IntegrationModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'orbitId', objects, saveLinks: saveLinks);
  }
}

extension IntegrationModelQueryWhereSort
    on QueryBuilder<IntegrationModel, IntegrationModel, QWhere> {
  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IntegrationModelQueryWhere
    on QueryBuilder<IntegrationModel, IntegrationModel, QWhereClause> {
  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause>
  orbitIdEqualTo(String orbitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'orbitId', value: [orbitId]),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterWhereClause>
  orbitIdNotEqualTo(String orbitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orbitId',
                lower: [],
                upper: [orbitId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orbitId',
                lower: [orbitId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orbitId',
                lower: [orbitId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orbitId',
                lower: [],
                upper: [orbitId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IntegrationModelQueryFilter
    on QueryBuilder<IntegrationModel, IntegrationModel, QFilterCondition> {
  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  isSupportedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSupported', value: value),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSync'),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSync'),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSync', value: value),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSync',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSync',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  lastSyncBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSync',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'metadataJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'metadataJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'metadataJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'metadataJson', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  metadataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'metadataJson', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
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

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orbitId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'orbitId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'orbitId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orbitId', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  orbitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'orbitId', value: ''),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  statusEqualTo(IntegrationStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  statusGreaterThan(IntegrationStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  statusLessThan(IntegrationStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterFilterCondition>
  statusBetween(
    IntegrationStatus lower,
    IntegrationStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension IntegrationModelQueryObject
    on QueryBuilder<IntegrationModel, IntegrationModel, QFilterCondition> {}

extension IntegrationModelQueryLinks
    on QueryBuilder<IntegrationModel, IntegrationModel, QFilterCondition> {}

extension IntegrationModelQuerySortBy
    on QueryBuilder<IntegrationModel, IntegrationModel, QSortBy> {
  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByOrbitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orbitId', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByOrbitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orbitId', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension IntegrationModelQuerySortThenBy
    on QueryBuilder<IntegrationModel, IntegrationModel, QSortThenBy> {
  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSync', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByMetadataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByMetadataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadataJson', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByOrbitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orbitId', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByOrbitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orbitId', Sort.desc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension IntegrationModelQueryWhereDistinct
    on QueryBuilder<IntegrationModel, IntegrationModel, QDistinct> {
  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct>
  distinctByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSupported');
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct>
  distinctByLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSync');
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct>
  distinctByMetadataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct>
  distinctByOrbitId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orbitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IntegrationModel, IntegrationModel, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension IntegrationModelQueryProperty
    on QueryBuilder<IntegrationModel, IntegrationModel, QQueryProperty> {
  QueryBuilder<IntegrationModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IntegrationModel, bool, QQueryOperations> isSupportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSupported');
    });
  }

  QueryBuilder<IntegrationModel, DateTime?, QQueryOperations>
  lastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSync');
    });
  }

  QueryBuilder<IntegrationModel, String, QQueryOperations>
  metadataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadataJson');
    });
  }

  QueryBuilder<IntegrationModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IntegrationModel, String, QQueryOperations> orbitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orbitId');
    });
  }

  QueryBuilder<IntegrationModel, IntegrationStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
