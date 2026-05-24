// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserConfigCollection on Isar {
  IsarCollection<UserConfig> get userConfigs => this.collection();
}

const UserConfigSchema = CollectionSchema(
  name: r'UserConfig',
  id: 1844971189088430043,
  properties: {
    r'isOnboarded': PropertySchema(
      id: 0,
      name: r'isOnboarded',
      type: IsarType.bool,
    ),
    r'monthlyBudget': PropertySchema(
      id: 1,
      name: r'monthlyBudget',
      type: IsarType.double,
    ),
    r'resetDay': PropertySchema(
      id: 2,
      name: r'resetDay',
      type: IsarType.long,
    )
  },
  estimateSize: _userConfigEstimateSize,
  serialize: _userConfigSerialize,
  deserialize: _userConfigDeserialize,
  deserializeProp: _userConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userConfigGetId,
  getLinks: _userConfigGetLinks,
  attach: _userConfigAttach,
  version: '3.1.0+1',
);

int _userConfigEstimateSize(
  UserConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userConfigSerialize(
  UserConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isOnboarded);
  writer.writeDouble(offsets[1], object.monthlyBudget);
  writer.writeLong(offsets[2], object.resetDay);
}

UserConfig _userConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserConfig();
  object.id = id;
  object.isOnboarded = reader.readBool(offsets[0]);
  object.monthlyBudget = reader.readDouble(offsets[1]);
  object.resetDay = reader.readLong(offsets[2]);
  return object;
}

P _userConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userConfigGetId(UserConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userConfigGetLinks(UserConfig object) {
  return [];
}

void _userConfigAttach(IsarCollection<dynamic> col, Id id, UserConfig object) {
  object.id = id;
}

extension UserConfigQueryWhereSort
    on QueryBuilder<UserConfig, UserConfig, QWhere> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserConfigQueryWhere
    on QueryBuilder<UserConfig, UserConfig, QWhereClause> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idBetween(
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

extension UserConfigQueryFilter
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {
  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      isOnboardedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOnboarded',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      monthlyBudgetEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      monthlyBudgetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      monthlyBudgetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      monthlyBudgetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyBudget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> resetDayEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      resetDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> resetDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resetDay',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> resetDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resetDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserConfigQueryObject
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQueryLinks
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQuerySortBy
    on QueryBuilder<UserConfig, UserConfig, QSortBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByIsOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboarded', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByIsOnboardedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboarded', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyBudget', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByMonthlyBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyBudget', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDay', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByResetDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDay', Sort.desc);
    });
  }
}

extension UserConfigQuerySortThenBy
    on QueryBuilder<UserConfig, UserConfig, QSortThenBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIsOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboarded', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIsOnboardedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboarded', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyBudget', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByMonthlyBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyBudget', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDay', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByResetDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDay', Sort.desc);
    });
  }
}

extension UserConfigQueryWhereDistinct
    on QueryBuilder<UserConfig, UserConfig, QDistinct> {
  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByIsOnboarded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnboarded');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyBudget');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByResetDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resetDay');
    });
  }
}

extension UserConfigQueryProperty
    on QueryBuilder<UserConfig, UserConfig, QQueryProperty> {
  QueryBuilder<UserConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserConfig, bool, QQueryOperations> isOnboardedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnboarded');
    });
  }

  QueryBuilder<UserConfig, double, QQueryOperations> monthlyBudgetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyBudget');
    });
  }

  QueryBuilder<UserConfig, int, QQueryOperations> resetDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resetDay');
    });
  }
}
